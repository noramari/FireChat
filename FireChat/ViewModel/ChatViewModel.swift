//
//  ChatViewModel.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatViewModel: ObservableObject {

    @Published var errorMessage = ""

    @Published var chatMessages = [Message]()
    @Published var lastMessageId: String = ""

    var firestoreListener: ListenerRegistration?

    var receivingUser: User?

    init(receivingUser: User?) {
        self.receivingUser = receivingUser

        fetchMessages()
    }

    func fetchMessages() {
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = receivingUser?.uid else { return }

        firestoreListener?.remove()
        chatMessages.removeAll()

        firestoreListener = FirebaseManager.shared.firestore.collection("messages")
            .document(fromID)
            .collection(toID)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen to messages: \(error.localizedDescription)"
                    print("Failed to listen to messages:", error.localizedDescription)
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })

                if let id = self.chatMessages.last?.documentID {
                    self.lastMessageId = id
                    print(self.lastMessageId)
                }
            }
    }

    func sendMessage(message: String) {
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = receivingUser?.uid else { return }

        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromID)
            .collection(toID)
            .document()

        let messageData = ["fromID": fromID, "toId": toID, "text": message, "timestamp": Timestamp()] as [String : Any]
        print(messageData)

        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message: \(error.localizedDescription)"
                print("Failed to save message:", error.localizedDescription)
                return
            }

            self.persistRecentMessage(message: message)
        }

        let recipientMessageDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toID)
            .collection(fromID)
            .document()

        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message: \(error.localizedDescription)"
                print("Failed to save message:", error.localizedDescription)
                return
            }
        }
    }

    private func persistRecentMessage(message: String) {
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        print(currentUser)
        guard let receivingUser = receivingUser else { return }
        print(receivingUser)

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = self.receivingUser?.uid else { return }

        let document = FirebaseManager.shared.firestore.collection(FirebaseConstants.recent_messages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toID)

        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: message,
            FirebaseConstants.fromID: uid,
            FirebaseConstants.toId: toID,
            FirebaseConstants.imageUrl: receivingUser.imageURL,
            FirebaseConstants.displayName: receivingUser.displayName,
            FirebaseConstants.email: receivingUser.email
        ] as [String : Any]

        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error.localizedDescription)"
                print("Failed to save recent message:", error.localizedDescription)
                return
            }
        }

        let recipientDocument = FirebaseManager.shared.firestore.collection(FirebaseConstants.recent_messages)
            .document(toID)
            .collection(FirebaseConstants.messages)
            .document(uid)

        let recipientData = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: message,
            FirebaseConstants.fromID: uid,
            FirebaseConstants.toId: toID,
            FirebaseConstants.imageUrl: currentUser.imageURL,
            FirebaseConstants.displayName: currentUser.displayName,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]

        recipientDocument.setData(recipientData) { error in
            if let error = error {
                self.errorMessage = "Failed to save recipient recent message: \(error.localizedDescription)"
                print("Failed to save recipient recent message:", error.localizedDescription)
                return
            }
        }
    }
}
