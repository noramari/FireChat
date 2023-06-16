//
//  MessageBubble.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message

    @State private var showTime = false

    var isMessageReceived: Bool {
        message.toId == FirebaseManager.shared.auth.currentUser?.uid
    }

    var body: some View {
        VStack(alignment: isMessageReceived ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(isMessageReceived ? Color("Gray") : Color("Peach"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: isMessageReceived ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }

            if showTime {
                Text("\(message.timestamp.dateValue().formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(isMessageReceived ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: isMessageReceived ? .leading : .trailing)
        .padding(isMessageReceived ? .leading : .trailing)
        .padding(.horizontal)
    }
}
