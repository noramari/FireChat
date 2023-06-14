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

    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.displayName = data["displayName"] as? String ?? email.components(separatedBy: "@")[0].capitalized
        self.imageURL = data["imageURL"] as? String ?? ""
    }
}
