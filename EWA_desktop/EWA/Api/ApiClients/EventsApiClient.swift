//
//  EventsApiClient.swift
//  EWA
//
//  Created by Дарья Жданок on 12.04.26.
//


import Foundation
import UIKit

final class EventsApClient {
    
    static let shared = EventsApClient()
    private let baseURL = "http://127.0.0.1:8080"
    
    private init() {}
    
    func getEventById(id: String) async throws -> EventResponse{
        
        guard let url = URL(string: baseURL + "/api/events/\(id)") else {
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
        let decoded = try decoder.decode(EventResponse.self, from: data)
        
        return decoded
    }
}
