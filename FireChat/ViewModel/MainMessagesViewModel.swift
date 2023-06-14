//
//  MainMessagesViewModel.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation

class MainMessagesViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var currentUser: User?

    init() {
        fetchCurrentUser()
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
        }
    }

    func handleLogOut() {
        try? FirebaseManager.shared.auth.signOut()
    }
}
