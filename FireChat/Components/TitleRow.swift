//
//  TitleRow.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI

struct TitleRow: View {
    var image = "ProfilePic"
    var name = "Sarah Tanaka"

    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            }

            VStack(alignment: .leading) {
                Text(name)
                    .font(Font.custom("Poppins-SemiBold", size: 30, relativeTo: .title))

                Text("Online")
                    .font(Font.custom("Poppins-Regular", size: 12, relativeTo: .caption))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "phone.fill")
                .foregroundColor(.gray)
                .padding(10)
                .background(.white)
                .cornerRadius(50)
        }
        .padding()
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
    }
}
