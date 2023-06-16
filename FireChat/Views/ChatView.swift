//
//  ChatView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct ChatView: View {
//    let chatUser: User?

//    init(chatUser: User?) {
//        self.chatUser = chatUser
//        self.vm = .init(receivingUser: chatUser)
//    }

    @ObservedObject var vm: ChatViewModel

    var body: some View {
        NavigationStack {
            VStack {
                ChatTitleRow(chatUser: vm.receivingUser)

                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(vm.chatMessages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(25, corners: [.topLeft, .topRight])
                    .onAppear() {
                        proxy.scrollTo(vm.lastMessageId, anchor: .bottom)
                    }
                    .onChange(of: vm.lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color("Peach"))
            .onDisappear {
                vm.firestoreListener?.remove()
            }

            MessageField(receivingUser: vm.receivingUser)
        }
        .tint(.black)
        .font(Font.custom("Poppins-Medium", size: 16))
    }
}
