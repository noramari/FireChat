//
//  TestAccountBlock.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI

struct TestAccountBlock: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.black, Color("PeachFont"))
                    .font(Font.custom("Poppins-SemiBold", size: 18))
                VStack(alignment: .leading) {
                    Text("Test Account")
                        .font(Font.custom("Poppins-SemiBold", size: 14))
                    Text(verbatim: "Email: test@selinan.com")

                    Text("Password: test123")
                }
                Spacer()
            }
            .padding()
        }
        .frame(width: 300)
        .font(Font.custom("Poppins-Medium", size: 14))
        .background(Color("Peach")).opacity(0.30)
        .cornerRadius(20)
        .padding()
    }
}

struct TestAccountBlock_Previews: PreviewProvider {
    static var previews: some View {
        TestAccountBlock()
    }
}
