//
//  UserApiClient.swift
//  EWA
//
//  Created by Дарья Жданок on 13.04.26.
//

import Foundation
import UIKit

struct UserResponseStatus: Decodable {
    let status: String
}

final class UserApiClient {
    
    static let shared = UserApiClient()
    private let baseURL = Environment.current.baseURL
    
    private init() {}
    
    func addUserToDataBase(user: UserResponse) async throws -> UserResponseStatus{
        
        guard let url = URL(string: baseURL + "/api/user/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(UserResponseStatus.self, from: data)
    }
    
    func updateUserAtBase(user: UserResponse) async throws -> UserResponseStatus{
        
        guard let url = URL(string: baseURL + "/api/user/update") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(UserResponseStatus.self, from: data)
    }
    
    func getUserById(id: String) async throws -> UserResponse{
        
        guard let url = URL(string: baseURL + "/api/user/\(id)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(UserResponse.self, from: data)
        
        return decoded
    }
    
    func addToBlacklist(
        userId: String,
        blockedUserId: String
    ) async throws -> Bool {
        
        guard let url = URL(string: baseURL + "/api/user/blacklist/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "userId": userId,
            "blockedUserId": blockedUserId
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return true
    }
    
    func deleteFromBlacklist(
        userId: String,
        blockedUserId: String
    ) async throws -> Bool {
        
        guard let url = URL(string: baseURL + "/api/user/blacklist/delete") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "userId": userId,
            "blockedUserId": blockedUserId
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return true
    }
    
    func getBlackList(userId: String) async throws -> [UserResponse] {
        
        guard let url = URL(string: baseURL + "/api/user/blacklist/\(userId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode([UserResponse].self, from: data)
        
        return decoded
    }
}
