//
//  LogInView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LogInView: View {
    @State var isLoginMode = true
    @State var email: String = ""
    @State var password: String = ""
    @State var image: UIImage?

    @State var shouldShowImagePicker = false
    @FocusState private var passwordIsFocused: Bool
    @FocusState private var emailIsFocused: Bool

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("🔥 FireChat")
                    .font(Font.custom("Poppins-SemiBold", size: 30, relativeTo: .title))

                Spacer()

                // MARK: - ログイン
                form

                // MARK: - テスト用アカウント
                if isLoginMode {
                    TestAccountBlock()

                    Spacer()

                // MARK: - アカウント作成ボタン
                    Group {
                        Text("New user?")

                        Button {
                            isLoginMode = false
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "person.badge.plus")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.black, Color("PeachFont"))
                                    .font(Font.custom("Poppins-SemiBold", size: 18))
                                Text("Create Account")
                            }
                            .foregroundColor(Color("PeachFont"))
                            .padding(.horizontal, 20)
                            .padding(.vertical)
                        }
                        .background(Color("Peach"))
                        .cornerRadius(50)
                        .padding(.bottom)
                    }
                } else {
                    Spacer()

                    Button {
                        isLoginMode = true
                        loginStatusMessage = ""
                        email = ""
                        password = ""
                        image = nil
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.black)
                    }
                }
            }
            .font(Font.custom("Poppins-Medium", size: 18))
        }
    }

    var form: some View {
        VStack {
            if !isLoginMode {
                Text("Create Account")
                    .font(Font.custom("Poppins-SemiBold", size: 20))

                // Image Picker
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                    } else {
                        Image("SampleImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
//                        Image(systemName: "person.circle")
//                            .foregroundStyle(.black, Color("PeachFont"))
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 100)
//                            .font(Font.custom("Poppins-Regular", size: 64))
                    }
                }
                .padding()
            }

            Group {
                TextField("\(Image(systemName: "person.fill")) Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .focused($emailIsFocused)

                SecureField("\(Image(systemName: "lock.fill")) Password", text: $password)
                    .focused($passwordIsFocused)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(Color("Gray"))
            .cornerRadius(20)

            Button {
                emailIsFocused = false
                passwordIsFocused = false
                handleFormAction()
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: isLoginMode ? "arrow.forward.circle" : "person.badge.plus")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, Color("PeachFont"))
                        .font(Font.custom("Poppins-SemiBold", size: 18))
                    Text(isLoginMode ? "Login" : "Create Account")
                }
                .foregroundColor(Color("PeachFont"))
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .background(Color("Peach"))
            .cornerRadius(50)

            Text(self.loginStatusMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: 300)
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }

    private func handleFormAction() {
        if isLoginMode {
            loginUser()
        } else {
            registerUser()
        }
    }

    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginStatusMessage = "Failed to log in: \(error.localizedDescription)"
                print("Failed to log in:", error.localizedDescription)
                return
            }

            self.loginStatusMessage = "Succesfully logged in: \(result?.user.uid ?? "")"
            print("Succesfully logged in: \(result?.user.uid ?? "")")
        }
    }

    @State var loginStatusMessage = ""

    private func registerUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {result, error in
            if let error = error {
                self.loginStatusMessage = "Failed to create account: \(error.localizedDescription)"
                print("Failed to create account:", error.localizedDescription)
                return
            }

            self.loginStatusMessage = "Succesfully created user: \(result?.user.uid ?? "")"
            print("Succesfully created user: \(result?.user.uid ?? "")")
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
