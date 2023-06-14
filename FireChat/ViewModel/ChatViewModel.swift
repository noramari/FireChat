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

    init() {
    }

    func sendMessage(message: String, receiverID: String) {
        print(message)
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let toID = receiverID

        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .document()

        let messageData = ["fromID": fromID, "toId": toID, "text": message, "timestamp": Timestamp()] as [String : Any]

        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message: \(error.localizedDescription)"
                print("Failed to save message:", error.localizedDescription)
                return
            }
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
}
