//
//  VideoSyncEvent.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import Foundation

struct VideoSyncEvent: Codable {
    let roomId: String
    let userId: String
    let action: VideoSyncAction
    let currentTime: Double
    let sentAt: Double
}
