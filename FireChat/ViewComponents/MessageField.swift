//
//  MessageField.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct MessageField: View {
    @ObservedObject private var vm = ChatViewModel()

    var receivingUser: User?

    @State private var message = ""

    var body: some View {
        HStack {
            Button {

            } label: {
                Image(systemName: "photo.on.rectangle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.black, Color("PeachFont"))
            }

            CustomTextField(placeholder: Text("Enter your message here"), text: $message)

            Button {
                vm.sendMessage(message: message, receiverID: receivingUser?.uid ?? "")
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor( (message == "") ? .white : .black )
                    .padding(10)
                    .background(Color("Peach"))
                    .cornerRadius(50)
            }
            .disabled(message == "")
        }
        .padding(.leading, 20)
        .padding(.trailing)
        .padding(.vertical, 10)
        .background(Color("Gray"))
        .cornerRadius(50)
        .padding()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.4)
            }

            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
