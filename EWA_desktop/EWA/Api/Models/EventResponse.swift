//
//  Untitled.swift
//  EWA
//
//  Created by Дарья Жданок on 12.04.26.
//
import Foundation

struct EventResponse: Decodable, Encodable {
    let id: String
    let userId: String
    let name: String
    let category: String
    let date: String
    let time: String
    let place: String
    let description: String
    let comment: String
    let user: UserResponse
}
