//
//  Message.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable {

    var id: String { documentID }

    let documentID: String

    var toId: String
    var fromId: String
    var text: String
    var timestamp: Timestamp

    init(documentId: String, data: [String: Any]) {
        self.documentID = documentId
        self.toId = data["toId"] as? String ?? ""
        self.fromId = data["fromID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
