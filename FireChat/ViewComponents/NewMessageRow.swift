//
//  NewMessageRow.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI

struct NewMessageRow: View {
    var user: User

    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: user.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(80)
                } placeholder: {
                    ProgressView()
                }

//                Image(systemName: "circle.fill")
//                    .foregroundColor(.green)
//                    .font(Font.custom("Poppins-SemiBold", size: 12))
//                    .offset(x: -3, y: -3)
            }

            VStack(alignment: .leading) {
                Text(user.displayName)
                    .font(Font.custom("Poppins-SemiBold", size: 20, relativeTo: .title))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
