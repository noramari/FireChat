//
//  User.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var password: String
    var displayName: String
}
