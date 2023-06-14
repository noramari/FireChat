//
//  ChatTitleRow.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct ChatTitleRow: View {
    let chatUser: User?

    @State private var isShowingAlert = false

    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: chatUser?.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                } placeholder: {
                    ProgressView()
                }

                Image(systemName: "circle.fill")
                    .foregroundColor(.green)
                    .font(Font.custom("Poppins-SemiBold", size: 12))
            }

            VStack(alignment: .leading) {
                Text(chatUser?.displayName ?? "User Name")
                    .font(Font.custom("Poppins-SemiBold", size: 30, relativeTo: .title))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "phone.fill")
                .foregroundColor(.gray)
                .padding(10)
                .background(.white)
                .cornerRadius(50)
                .onTapGesture {
                    isShowingAlert = true
                }
                .alert("This user is not available for calls", isPresented: $isShowingAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
        .padding()
    }
}
