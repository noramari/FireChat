//
//  ContentView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct ContentView: View {
    @StateObject var messagesManager = MessagesManager()

    var sampleMessages = ["Hello you", "How are you doing?", "I've been building SwiftUI applications from scratch and it's so much fun!"]

    var body: some View {
        VStack {
            VStack {
                TitleRow()

                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesManager.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(25, corners: [.topLeft, .topRight])
                    .onChange(of: messagesManager) { id in
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            .background(Color("Peach"))

            MessageField()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
