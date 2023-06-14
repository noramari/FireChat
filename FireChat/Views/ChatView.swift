//
//  ChatView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject private var vm = ChatViewModel()
    
    let chatUser: User?

    var body: some View {
        NavigationStack {
            VStack {
                ChatTitleRow(chatUser: chatUser)

                ScrollViewReader { proxy in
                    ScrollView {
//                        ForEach(messagesManager.messages, id: \.id) { message in
//                            MessageBubble(message: message)
//                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(25, corners: [.topLeft, .topRight])
//                    .onChange(of: messagesManager.lastMessageId) { id in
//                        withAnimation {
//                            proxy.scrollTo(id, anchor: .bottom)
//                        }
//                    }
                }
            }
            .background(Color("Peach"))

            MessageField(receivingUser: chatUser)
        }
        .tint(.black)
        .font(Font.custom("Poppins-Medium", size: 16))
    }
}
