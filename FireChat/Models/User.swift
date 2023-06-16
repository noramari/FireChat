//
//  User.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation

struct User: Identifiable, Hashable {

    var id: String { uid }
    
    var uid: String
    var email: String
    var displayName: String
    var imageURL: String
    var phoneNumber: String

    init(data: [String: Any]) {
        self.uid = data[FirebaseConstants.uid] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String ?? ""
        self.displayName = data[FirebaseConstants.displayName] as? String ?? email.components(separatedBy: "@")[0].capitalized
        self.imageURL = data[FirebaseConstants.imageUrl] as? String ?? ""
        self.phoneNumber = data[FirebaseConstants.phoneNumber] as? String ?? ""
    }
}
