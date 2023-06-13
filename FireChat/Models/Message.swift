//
//  Message.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
