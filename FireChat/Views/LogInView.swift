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
    @ObservedObject private var vm = LogInViewModel()

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var image: UIImage?

    @State private var isLoginMode = true
    @State private var shouldShowImagePicker = false

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
                        vm.loginStatusMessage = ""
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
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedIn) {
            MainMessagesView(isMessagesShown: $vm.isUserCurrentlyLoggedIn)
        }
    }

    // MARK: - Form
    private var form: some View {
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
                        ZStack {
                            Image("SampleImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 2)
                                )
                        }
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

            Text(vm.loginStatusMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: 300)
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }

    func handleFormAction() {
        if isLoginMode {
            vm.loginUser(email: email, password: password)
        } else {
            vm.registerUser(email: email, password: password, image: image)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
