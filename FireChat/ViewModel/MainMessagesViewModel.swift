//
//  MainMessagesViewModel.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class MainMessagesViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var currentUser: User?
    @Published var receivingUser: User?
    @Published var recentMessages = [RecentMessage]()

    private var firestoreListener: ListenerRegistration?

    init() {
        fetchCurrentUser()
        fetchRecentMessages()
    }

    private func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find Firebase UID"
            return
        }

        firestoreListener?.remove()
        self.recentMessages.removeAll()

        firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener({ querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch recent messages: \(error.localizedDescription)"
                    print("Failed to fetch recent messages:", error.localizedDescription)
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                    let docID = change.document.documentID

                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentID == docID
                    }) {
                        self.recentMessages.remove(at: index)
                    }

                    self.recentMessages.insert(.init(documentID: docID, data: change.document.data()), at: 0)
                })
            })

    }

    private func fetchCurrentUser() {
        self.errorMessage = "Fetching User"
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find Firebase UID"
            return
        }

        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error.localizedDescription)"
                print("Failed to fetch current user:", error.localizedDescription)
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }

            self.currentUser = .init(data: data)
            FirebaseManager.shared.currentUser = self.currentUser
        }
    }

    func handleLogOut() {
        try? FirebaseManager.shared.auth.signOut()
    }
}
