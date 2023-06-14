//
//  NewMessageViewModel.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation

class NewMessageViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var users = [User]()

    init() {
        fetchUsers()
    }

    private func fetchUsers() {
        self.errorMessage = "Fetching Users"

        FirebaseManager.shared.firestore.collection("users").getDocuments { documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
                print("Failed to fetch users:", error.localizedDescription)
                return
            }

            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                let user = User(data: data)
                if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(.init(data: data))
                }
            })
        }
    }
}
