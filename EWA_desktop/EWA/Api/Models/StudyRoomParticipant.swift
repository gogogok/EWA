//
//  StudyRoomParticipant.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import Foundation

struct StudyRoomParticipant: Codable {
    let id: String?
    let roomId: String?
    let userId: String
    let username: String
    let iconName: String?
}
