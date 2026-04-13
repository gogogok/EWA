//
//  Untitled.swift
//  EWA
//
//  Created by Дарья Жданок on 12.04.26.
//
import Foundation

struct EventResponse: Decodable {
    let id: Int
    let userId: Int
    let name: String
    let category: String
    let dateTime: String
    let place: String
    let description: String
    let comment: String
    let user: UserResponse
}
