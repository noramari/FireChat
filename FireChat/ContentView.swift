//
//  ContentView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct ContentView: View {
    var sampleMessages = ["Hello you", "How are you doing?", "I've been building SwiftUI applications from scratch and it's so much fun!"]

    var body: some View {
        VStack {
            VStack {
                TitleRow()

                ScrollView {
                    ForEach(sampleMessages, id: \.self) { text in
                        MessageBubble(message: Message(id: "123", text: text, received: true, timestamp: Date()))
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(25, corners: [.topLeft, .topRight])
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
