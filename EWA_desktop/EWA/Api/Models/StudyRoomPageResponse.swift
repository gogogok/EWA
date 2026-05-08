//
//  StudyRoomPageResponse.swift
//  EWA
//
//  Created by Дарья Жданок on 5.05.26.
//

struct StudyRoomPageResponse: Decodable {
    let content: [StudyResponse]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let last: Bool
}
