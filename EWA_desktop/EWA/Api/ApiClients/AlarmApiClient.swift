//
//  AlarmApiClient.swift
//  EWA
//
//  Created by Дарья Жданок on 23.04.26.
//
import Foundation

struct AlarmsResponseStatus: Decodable {
    let status: String
}

struct BackendErrorResponse: Decodable {
    let message: String
}

enum BackendError: Error {
    case message(String)
    case badServerResponse
}

final class AlarmApiClient {
    
    static let shared = AlarmApiClient()
    private let baseURL = Environment.current.baseURL
    
    private init() {}
    
    func fetchAvailableAlarms(page: Int, size: Int, type: String) async throws -> AlarmsPageResponse {
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            throw URLError(.badServerResponse)
        }
        var components = URLComponents(string: baseURL + "/api/alarms")
        components?.queryItems = [
            URLQueryItem(name: "userId", value: String(userId)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size)),
            URLQueryItem(name: "type", value: type)
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
        return try decoder.decode(AlarmsPageResponse.self, from: data)
    }
    
    func addAlarmToDataBase(alarm: AlarmResponse) async throws -> AlarmResponse{
        
        guard let url = URL(string: baseURL + "/api/alarms/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(alarm)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(AlarmResponse.self, from: data)
    }
    
    func getRegisteredAlarmsByUserId(userId: String) async throws -> [AlarmResponse] {
        
        guard let url = URL(string: baseURL + "/api/alarmsregistration/\(userId)") else {
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
        let decoded = try decoder.decode([AlarmResponse].self, from: data)
        
        return decoded
    }
    
    func getCreatedEAlarmsByUserId(userId: String) async throws -> [AlarmResponse] {
        
        guard let url = URL(string: baseURL + "/api/alarms/my/\(userId)") else {
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
        let decoded = try decoder.decode([AlarmResponse].self, from: data)
        
        return decoded
    }
    
    func addAlarmRegistration(
        alarmId: String,
        userId: String?,
        stutus: String
    ) async throws -> AlarmResponse {
        
        guard let userId else {
            throw URLError(.badURL)
        }
        
        guard let url = URL(string: baseURL + "/api/alarmsregistration/addToAlarm/\(alarmId)/\(userId)/\(stutus)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw BackendError.badServerResponse
        }
        
        print("STATUS CODE:", http.statusCode)
        
        if let body = String(data: data, encoding: .utf8) {
            print("BODY:", body)
        }
        
        guard 200..<300 ~= http.statusCode else {
            let backendError = try? JSONDecoder().decode(
                BackendErrorResponse.self,
                from: data
            )
            
            throw BackendError.message(
                backendError?.message ?? "Ошибка сервера: \(http.statusCode)"
            )
        }
        
        return try JSONDecoder().decode(AlarmResponse.self, from: data)
    }
    
    func leaveAlarm(alarmId: String, userId: String?) async throws -> AlarmsResponseStatus{
        
        guard let userId else {
            throw URLError(.badURL)
        }
        guard let url = URL(string: baseURL + "/api/alarmsregistration/\(userId)/\(alarmId)/leave") else {
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
        
        return try JSONDecoder().decode(AlarmsResponseStatus.self, from: data)
    }
    
    func deleteAlarm(alarmId: String) async throws -> AlarmsResponseStatus{
        
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            throw URLError(.badURL)
        }
        
        guard let url = URL(string: baseURL + "/api/alarmsregistration/delete/\(alarmId)/\(userId)") else {
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
        
        return try JSONDecoder().decode(AlarmsResponseStatus.self, from: data)
    }
    
    func editAlarm(alarm: AlarmResponse) async throws -> AlarmsResponseStatus {
        
        guard let url = URL(string: baseURL + "/api/alarms/edit/\(alarm.id)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(alarm)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(AlarmsResponseStatus.self, from: data)
    }
    
}
