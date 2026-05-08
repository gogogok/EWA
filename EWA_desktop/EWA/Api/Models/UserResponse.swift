//
//  UserResponse.swift
//  EWA
//
//  Created by Дарья Жданок on 12.04.26.
//
import Foundation

struct UserResponse: Encodable, Decodable {
    let id: String
    let name: String
    let email: String
    let iconName: String
}
