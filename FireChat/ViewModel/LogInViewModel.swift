//
//  LogInViewModel.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI

class LogInViewModel: ObservableObject {

    private var sampleImage = Image("SampleImage")

    @Published var isUserCurrentlyLoggedIn = false
    @Published var loginStatusMessage = ""

    init() {
        DispatchQueue.main.async {
            self.checkIfLoggedIn()
        }
    }

    private func checkIfLoggedIn() {
        self.isUserCurrentlyLoggedIn = FirebaseManager.shared.auth.currentUser?.uid != nil
    }

    func loginUser(email: String, password: String) {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginStatusMessage = "Failed to log in: \(error.localizedDescription)"
                print("Failed to log in:", error.localizedDescription)
                return
            }

            self.loginStatusMessage = "Succesfully logged in: \(result?.user.uid ?? "")"
            print("Succesfully logged in: \(result?.user.uid ?? "")")
            self.isUserCurrentlyLoggedIn = true
            self.loginStatusMessage = ""
        }
    }

    func registerUser(email: String, password: String, image: UIImage?) {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {result, error in
            if let error = error {
                self.loginStatusMessage = "Failed to create account: \(error.localizedDescription)"
                print("Failed to create account:", error.localizedDescription)
                return
            }

            self.loginStatusMessage = "Succesfully created user: \(result?.user.uid ?? "")"
            print("Succesfully created user: \(result?.user.uid ?? "")")

            if let image = image {
                self.persistImageToStorage(image: image)
            } else {
                self.persistImageToStorage(image: UIImage(named: "SampleImage")!)
            }

            self.checkIfLoggedIn()
            self.loginStatusMessage = ""
        }
    }

    private func persistImageToStorage(image: UIImage) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.loginStatusMessage = "Failed to save image: \(error.localizedDescription)"
                print("Failed to save image:", error.localizedDescription)
                return
            }

            ref.downloadURL { url, error in
                if let error = error {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(error.localizedDescription)"
                    print("Failed to retrieve downloadURL:", error.localizedDescription)
                    return
                }

                self.loginStatusMessage = "Succesfully stored image with url: \(url?.absoluteString ?? "")"
                print("Succesfully stored image with url: \(url?.absoluteString ?? "")")

                guard let url = url else { return }
                self.storeUserInformation(imageURL: url)
                self.loginStatusMessage = ""
            }
        }
    }

    private func storeUserInformation(imageURL: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let email = FirebaseManager.shared.auth.currentUser?.email else { return }
        let displayName = email.components(separatedBy: "@")[0].capitalized
        let userData = [FirebaseConstants.email: email,
                        FirebaseConstants.uid: uid,
                        FirebaseConstants.imageUrl: imageURL.absoluteString,
                        FirebaseConstants.displayName: displayName]

        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                self.loginStatusMessage = "Failed to store user info: \(error.localizedDescription)"
                print("Failed to store user info:", error.localizedDescription)
                return
            }
            self.loginStatusMessage = ""
        }
    }
}
