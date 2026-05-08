//
//  AlarmsPageResponse.swift
//  EWA
//
//  Created by Дарья Жданок on 23.04.26.
//

struct AlarmsPageResponse: Decodable {
    let content: [AlarmResponse]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let last: Bool
}

