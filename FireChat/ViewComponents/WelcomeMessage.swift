//
//  WelcomeMessage.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/16.
//

import SwiftUI

struct WelcomeMessage: View {
    var body: some View {
        VStack() {
            VStack(alignment: .center) {
                Text("Welcome to FireChat 🔥")
                    .font(Font.custom("Poppins-SemiBold", size: 16))

                Text("Start chatting with interesting people by clicking 'New Message' below!")
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .font(Font.custom("Poppins-Medium", size: 16))
        .background(Color("Peach")).opacity(0.30)
        .cornerRadius(20)
        .padding()
    }
}

struct WelcomeMessage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeMessage()
    }
}
