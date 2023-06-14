//
//  MainMessagesView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI

struct MainMessagesView: View {
    @ObservedObject private var vm = MainMessagesViewModel()

    @Binding var isMessagesShown: Bool

    @State var chatUser: User?
    @State var isShowingNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false

    var body: some View {
        NavigationStack {
            VStack {
                MainMessagesTitle(isMessagesShown: $isMessagesShown)

                messages

                NavigationLink("", value: chatUser)
            }
            .background(Color("Peach"))
            .navigationDestination(isPresented: $shouldNavigateToChatLogView, destination: {
                ChatView(chatUser: chatUser)
            })
            .overlay(alignment: .bottom) {
                newMessageButton
            }
        }
        .font(Font.custom("Poppins-Medium", size: 16))
        .sheet(isPresented: $isShowingNewMessageScreen) {
            NewMessageView(didSelectNewUser: { user in
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
            })
        }
    }
    // MARK: - Messages
    var messages: some View {
        ScrollViewReader { proxy in
            ScrollView {
//                        ForEach(messagesManager.messages, id: \.id) { message in
//                            MessageBubble(message: message)
//                        }
                ForEach(0..<10, id: \.self) { num in
                    MainMessagesRow()
                }
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

    // MARK: - New Message Button
    var newMessageButton: some View {
        Button {
            isShowingNewMessageScreen.toggle()
        } label: {
            HStack(spacing: 5) {
                Spacer()
                Image(systemName: "plus.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.black, Color("PeachFont"))
                    .font(Font.custom("Poppins-SemiBold", size: 18))
                Text("New Message")
                Spacer()
            }
            .foregroundColor(Color("PeachFont"))
            .padding(.horizontal, 20)
            .padding(.vertical)
        }
        .background(Color("Peach"))
        .cornerRadius(50)
        .padding()
    }
}
