//
//  ChatMessage.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import Foundation

struct ChatMessage: Codable {
    let roomId: String
    let userId: String
    let username: String
    let text: String
    let createdAt: String?
}
