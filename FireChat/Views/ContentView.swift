//
//  ContentView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct ContentView: View {
//    @StateObject var messagesManager = MessagesManager()

    var body: some View {
        VStack {
            VStack {
                ChatTitleRow()

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

//            MessageField()
//                .environmentObject(messagesManager)
        }
        .font(Font.custom("Poppins-Medium", size: 16))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
