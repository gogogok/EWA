//
//  UserResponse.swift
//  EWA
//
//  Created by Дарья Жданок on 12.04.26.
//
import Foundation

struct UserResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let iconName: String
}
