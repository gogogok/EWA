//
//  EventsApiClient.swift
//  EWA
//
//  Created by Дарья Жданок on 12.04.26.
//
import Foundation
import UIKit

struct EventResponseStatus: Decodable {
    let status: String
}

final class EventsApClient {
    
    static let shared = EventsApClient()
    private let baseURL = Environment.current.baseURL
    
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
    
    func fetchAvailableEvents(page: Int, size: Int) async throws -> EventsPageResponse {
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            throw URLError(.badServerResponse)
        }
        var components = URLComponents(string: baseURL + "/api/events")
        components?.queryItems = [
            URLQueryItem(name: "userId", value: String(userId)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size))
        ]
        
        guard let url = components?.url else {
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
        return try decoder.decode(EventsPageResponse.self, from: data)
    }
    
    func addEventToDataBase(event: EventResponse) async throws -> EventResponseStatus{
        
        guard let url = URL(string: baseURL + "/api/events/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(event)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(EventResponseStatus.self, from: data)
    }
    
    func getRegisteredEventsByUserId(userId: String) async throws -> [EventResponse] {
        
        guard let url = URL(string: baseURL + "/api/eventsregistration/\(userId)") else {
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
        let decoded = try decoder.decode([EventResponse].self, from: data)
        
        return decoded
    }
    
    func getCreatedEventsByUserId(userId: String) async throws -> [EventResponse] {
        
        guard let url = URL(string: baseURL + "/api/events/my/\(userId)") else {
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
        let decoded = try decoder.decode([EventResponse].self, from: data)
        
        return decoded
    }
    
    func addEventRegistration(eventId: String, userId: String?) async throws -> EventResponseStatus{
        
        guard let userId else {
            throw URLError(.badURL)
        }
        guard let url = URL(string: baseURL + "/api/eventsregistration/addToEvent/\(eventId)/\(userId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(EventResponseStatus.self, from: data)
    }
    
    func leaveEvent(eventId: String, userId: String?) async throws -> EventResponseStatus{
        
        guard let userId else {
            throw URLError(.badURL)
        }
        guard let url = URL(string: baseURL + "/api/eventsregistration/\(userId)/\(eventId)/leave") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(EventResponseStatus.self, from: data)
    }
    
    func deleteEvent(eventId: String) async throws -> EventResponseStatus{
        
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            throw URLError(.badURL)
        }
        
        guard let url = URL(string: baseURL + "/api/eventsregistration/delete/\(eventId)/\(userId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(EventResponseStatus.self, from: data)
    }
    
    func editEvent(event: EventResponse) async throws -> EventResponseStatus{
        
        guard let url = URL(string: baseURL + "/api/events/edit/\(event.id)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(event)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(EventResponseStatus.self, from: data)
    }
}
