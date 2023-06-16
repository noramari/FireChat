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

    @State var chatReceivingUser: User?
    @State var isShowingNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false

    var chatViewModel = ChatViewModel(receivingUser: nil)

    var body: some View {
        NavigationStack {
            VStack {
                MainMessagesTitle(isMessagesShown: $isMessagesShown)

                NavigationLink("", value: chatReceivingUser)

                messages
            }
            .background(Color("Peach"))
            .navigationDestination(isPresented: $shouldNavigateToChatLogView, destination: {
                ChatView(vm: chatViewModel)
            })
            .overlay(alignment: .bottom) {
                newMessageButton
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack {
//                    Text("Footer")
                }
                .frame(maxWidth: .infinity)
                .background(.white)
            }
        }
        .font(Font.custom("Poppins-Medium", size: 16))
        .sheet(isPresented: $isShowingNewMessageScreen) {
            NewMessageView(didSelectNewUser: { user in
                self.shouldNavigateToChatLogView.toggle()
                self.chatReceivingUser = user
                self.chatViewModel.receivingUser = user
                self.chatViewModel.fetchMessages()
            })
        }
    }
    // MARK: - Messages
    var messages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(vm.recentMessages, id: \.id) { message in

                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == message.fromId ? message.toId : message.fromId
                        self.chatReceivingUser = .init(data: [FirebaseConstants.email: message.email, FirebaseConstants.imageUrl: message.imageURL, FirebaseConstants.uid: uid, FirebaseConstants.displayName: message.displayName, FirebaseConstants.phoneNumber: message.phoneNumber])
                        self.chatViewModel.receivingUser = self.chatReceivingUser
                        self.chatViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 20) {
                            ZStack(alignment: .bottomTrailing) {
                                AsyncImage(url: URL(string: message.imageURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(50)
                                } placeholder: {
                                    ProgressView()
                                }

//                                Image(systemName: "circle.fill")
//                                    .foregroundColor(.green)
//                                    .font(Font.custom("Poppins-SemiBold", size: 12))
                            }

                            VStack(alignment: .leading) {
                                Text(message.displayName)
                                    .font(Font.custom("Poppins-SemiBold", size: 20, relativeTo: .title))
                                if FirebaseManager.shared.auth.currentUser?.uid == message.fromId {
                                    Text("You: \(message.text)")
                                        .font(Font.custom("Poppins-Regular", size: 16))
                                        .lineLimit(2, reservesSpace: false)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text(message.text)
                                        .lineLimit(2, reservesSpace: false)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Text(message.timeAgo)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    }
                    Divider()

                }
            }
            .padding(.top, 10)
            .background(.white)
            .cornerRadius(25, corners: [.topLeft, .topRight])
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
