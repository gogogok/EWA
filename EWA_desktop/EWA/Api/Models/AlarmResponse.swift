//
//  AlarmResponse.swift
//  EWA
//
//  Created by Дарья Жданок on 23.04.26.
//

import Foundation

struct AlarmResponse: Decodable, Encodable {
    let id: String
    let userId: String
    let description: String
    let category: String
    let comment: String
    let categoryHexColor: String
    let date: String
    let time: String
    let user: UserResponse
    let countPart: Int
}
