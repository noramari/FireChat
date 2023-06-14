//
//  FirebaseManager.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseManager: NSObject {

    let auth: Auth

    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()

        self.auth = Auth.auth()

        super.init()
    }
}
