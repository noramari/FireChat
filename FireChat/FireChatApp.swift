//
//  FireChatApp.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestoreSwift

@main
struct FireChatApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
