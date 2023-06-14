//
//  MainMessagesRow.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI

struct MainMessagesRow: View {
    var image = "ProfilePic"
    var name = "Sarah Tanaka"
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)

                Image(systemName: "circle.fill")
                    .foregroundColor(.green)
                    .font(Font.custom("Poppins-SemiBold", size: 12))
            }

            VStack(alignment: .leading) {
                Text(name)
                    .font(Font.custom("Poppins-SemiBold", size: 20, relativeTo: .title))
                Text("Message here")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("22d")
        }
        .padding(.horizontal)

        Divider()
    }
}

struct MainMessagesRow_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesRow()
    }
}
