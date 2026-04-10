//
//  ApiClient.swift
//  EWA
//
//  Created by Дарья Жданок on 11.04.26.
//

import Foundation

struct HealthResponse: Decodable {
    let status: String
}

final class APIClient {
    private let baseURL = "http://127.0.0.1:8080"

    func fetchHealth() async throws -> HealthResponse {
        guard let url = URL(string: "\(baseURL)/api/health") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(HealthResponse.self, from: data)
    }
}
