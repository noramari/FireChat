//
//  LogInView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct LogInView: View {
    @State var isLoginMode = true
    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
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
                } label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                }
            }
        }
        .font(Font.custom("Poppins-Medium", size: 18))
    }

    var form: some View {
        VStack {
            if !isLoginMode {
                Text("Create Account")
                    .font(Font.custom("Poppins-SemiBold", size: 20))
            }

            Group {
                TextField("\(Image(systemName: "person.fill")) Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                SecureField("\(Image(systemName: "lock.fill")) Password", text: $password)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(Color("Gray"))
            .cornerRadius(20)

            Button {
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
        }
        .padding()
        .frame(maxWidth: 300)
    }

    private func handleFormAction() {
        if isLoginMode {
            print("Login")
        } else {
            print(("Create Account"))
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
