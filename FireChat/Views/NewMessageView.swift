//
//  NewMessageView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI

struct NewMessageView: View {
    @ObservedObject private var vm = NewMessageViewModel()

    @Environment(\.dismiss) private var dismiss

    let didSelectNewUser: (User) -> ()

    var body: some View {
        VStack {
            HStack {
                Text("New Message")
                    .font(Font.custom("Poppins-SemiBold", size: 30, relativeTo: .title))

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(Font.custom("Poppins-Medium", size: 16))
                        .foregroundColor(Color("PeachFont"))
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .padding(.horizontal)

            ScrollView {
                ForEach(vm.users) { user in
                    NewMessageRow(user: user)
                        .onTapGesture {
                            didSelectNewUser(user)
                            dismiss()
                        }
                        .padding(.horizontal)

                    Divider()
                }
            }
        }
    }
}
