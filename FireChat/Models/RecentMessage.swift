//
//  RecentMessage.swift
//  FireChat
//
//  Created by Noora Maeda on 2023/06/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecentMessage: Identifiable {
    var id: String { documentID }

    let documentID: String
    let text, fromId, toId: String
    let email, displayName, imageURL: String
    let timestamp: Timestamp

    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.toId = data["toId"] as? String ?? ""
        self.fromId = data["fromID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.displayName = data["displayName"] as? String ?? email.components(separatedBy: "@")[0].capitalized
        self.imageURL = data["imageURL"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self.timestamp.dateValue(), relativeTo: Date())
    }
}
