//
//  EventsPageResponse.swift
//  EWA
//
//  Created by Дарья Жданок on 15.04.26.
//

struct EventsPageResponse: Decodable {
    let content: [EventResponse]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let last: Bool
}
