//
//  SettingsViewModel.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/15.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingsViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var currentUser: User?

    private var firestoreListener: ListenerRegistration?

    init() {
        fetchCurrentUser()
    }

    private func fetchCurrentUser() {
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

    func updateUserInfo(displayName: String?, image: UIImage?, phone: String?) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        if phone != nil {
            let formattedNumber = formatPhone(number: phone!)

            FirebaseManager.shared.firestore.collection("users").document(uid)
                .updateData(([FirebaseConstants.phoneNumber: formattedNumber])) { error in
                if let error = error {
                    self.errorMessage = "Failed to store user info: \(error.localizedDescription)"
                    print("Failed to store user info:", error.localizedDescription)
                    return
                }
                self.errorMessage = "Data Saved!"
            }
        } 

        if (displayName != nil) {
            FirebaseManager.shared.firestore.collection("users").document(uid)
                .updateData(([FirebaseConstants.displayName: displayName])) { error in
                if let error = error {
                    self.errorMessage = "Failed to store user info: \(error.localizedDescription)"
                    print("Failed to store user info:", error.localizedDescription)
                    return
                }
                self.errorMessage = "Data Saved!"
            }
        }

        if (image != nil) {
            saveImage(image: image!)
        }
    }

    func formatPhone(number: String) -> String {
        let tel = "tel://"
        return tel + number
    }

    func saveImage(image: UIImage) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.errorMessage = "Failed to save image: \(error.localizedDescription)"
                print("Failed to save image:", error.localizedDescription)
                return
            }

            ref.downloadURL { url, error in
                if let error = error {
                    self.errorMessage = "Failed to retrieve downloadURL: \(error.localizedDescription)"
                    print("Failed to retrieve downloadURL:", error.localizedDescription)
                    return
                }

                self.errorMessage = "Succesfully stored image with url: \(url?.absoluteString ?? "")"
                print("Succesfully stored image with url: \(url?.absoluteString ?? "")")

                guard let url = url else { return }

                FirebaseManager.shared.firestore.collection("users").document(uid)
                    .updateData(([FirebaseConstants.imageUrl: url.absoluteString])) { error in
                        if let error = error {
                            self.errorMessage = "Failed to store user info: \(error.localizedDescription)"
                            print("Failed to store user info:", error.localizedDescription)
                            return
                        }
                        self.errorMessage = "Image Saved!"
                    }
            }
        }
    }
}
