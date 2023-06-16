//
//  MainMessagesRow.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI
import FirebaseFirestore

struct MainMessagesRow: View {
    @ObservedObject var vm: ChatViewModel

    var message: RecentMessage
    var user: User

    var body: some View {
        NavigationLink {
            ChatView(vm: vm)
        } label: {
            HStack(spacing: 20) {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: user.imageURL)) { image in
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
                    Text(user.displayName)
                        .font(Font.custom("Poppins-SemiBold", size: 20, relativeTo: .title))
                    Text(message.text)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text(message.timeAgo)
            }
            .foregroundColor(.black)
            .padding(.horizontal)
        }
        .onAppear() {
            print(message)
            self.vm.receivingUser = user
            self.vm.fetchMessages()
        }
        Divider()
    }
}
