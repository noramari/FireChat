//
//  SettingsView.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/15.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: SettingsViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var displayName: String = ""
    @State private var phoneNumber: String = ""
    @State private var newImage: UIImage?

    @State private var shouldShowImagePicker = false

    @FocusState private var nameIsFocused: Bool
    @FocusState private var numberIsFocused: Bool

    init(displayName: String, phone: String) {
        self.vm = SettingsViewModel()
        self._nameIsFocused = FocusState()
        self._displayName = State(initialValue: displayName)
        self._phoneNumber = State(initialValue: phone.replacingOccurrences(of: "tel://", with: ""))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(Font.custom("Poppins-SemiBold", size: 30, relativeTo: .title))

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(Font.custom("Poppins-Medium", size: 16))
                        .foregroundColor(Color("PeachFont"))
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .padding(.horizontal)

            Spacer()

            form

            Spacer()
        }
        .onTapGesture {
            nameIsFocused = false
            numberIsFocused = false
        }
    }

    // MARK: - Form
    private var form: some View {
        VStack {
            // MARK: - Display Image
            Button {
                shouldShowImagePicker.toggle()
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    if newImage != nil {
                        Image(uiImage: newImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .cornerRadius(60)
                    }
                    if let image = vm.currentUser?.imageURL {
                        AsyncImage(url: URL(string: image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .cornerRadius(60)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image("SampleImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .cornerRadius(60)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, Color("PeachFont"))
                        .font(Font.custom("Poppins-SemiBold", size: 19))
                        .offset(x: -4, y: -4)
                }
            }
            .padding()

            // MARK: - Display Name
            TextField((vm.currentUser?.displayName ?? "Add Name"), text: $displayName)
                .font(Font.custom("Poppins-SemiBold", size: 30, relativeTo: .title))
                .multilineTextAlignment(.center)
                .background(.white)
                .focused($nameIsFocused)

            // MARK: - Phone Number
            HStack {
                Image(systemName: "phone.fill")
                    .font(Font.custom("Poppins-SemiBold", size: 18))
                    .padding()

                TextField((vm.currentUser?.phoneNumber.replacingOccurrences(of: "tel://", with: "") ?? "Add Phone Number"), text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .focused($numberIsFocused)
            }
            .background(Color("Gray"))
            .cornerRadius(20)

            Spacer()

            // MARK: - Save Button
            Button {
                nameIsFocused = false
                numberIsFocused = false
                vm.updateUserInfo(displayName: displayName, image: newImage, phone: phoneNumber)
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "square.and.arrow.down")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, Color("PeachFont"))
                        .font(Font.custom("Poppins-SemiBold", size: 18))
                    Text("Save Changes")
                }
                .foregroundColor(Color("PeachFont"))
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .background(Color("Peach"))
            .cornerRadius(50)

            Text(vm.errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
        .frame(maxWidth: 300)
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $newImage)
        }
    }
}
