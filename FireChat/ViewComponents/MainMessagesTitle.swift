//
//  MainMessagesTitle.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import SwiftUI

struct MainMessagesTitle: View {
    @ObservedObject private var vm = MainMessagesViewModel()

    @Binding var isMessagesShown: Bool

    @State var isShowingLogOutOptions = false

    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: vm.currentUser?.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                } placeholder: {
                    ProgressView()
                }

                Image(systemName: "circle.fill")
                    .foregroundColor(.green)
                    .font(Font.custom("Poppins-SemiBold", size: 12))
            }

            VStack(alignment: .leading) {
                Text(vm.currentUser?.displayName ?? "")
                    .font(Font.custom("Poppins-SemiBold", size: 30, relativeTo: .title))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                isShowingLogOutOptions.toggle()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.black, Color("PeachFont"))
                    .font(Font.custom("Poppins-SemiBold", size: 14))
                    .padding(10)
                    .background(.white)
                    .cornerRadius(50)
            }
        }
        .padding()
        .confirmationDialog("Log Out", isPresented: $isShowingLogOutOptions) {
            Button("Log Out", role: .destructive) {
                vm.handleLogOut()
                isMessagesShown = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}