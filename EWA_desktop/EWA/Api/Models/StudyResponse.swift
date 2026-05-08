//
//  StudyResponse.swift
//  EWA
//
//  Created by Дарья Жданок on 4.05.26.
//

struct StudyResponse: Decodable, Encodable {
    let id: String
    let userId: String
    let name: String
    let description: String
    let category: String
    let type: String
    let user: UserResponse
    let mediaUrl: String
    let password : String?
}
