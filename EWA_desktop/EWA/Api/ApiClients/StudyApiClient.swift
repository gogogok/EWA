//
//  StudyApiClient.swift
//  EWA
//
//  Created by Дарья Жданок on 5.05.26.
//

import Foundation

struct StudyResponseStatus: Decodable {
    let status: String
}

final class StudyApiClient {
    
    static let shared = StudyApiClient()
    private let baseURL = Environment.current.baseURL
    
    private init() {}
    
    func fetchRooms(page: Int, size: Int) async throws -> StudyRoomPageResponse {
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.id) else {
            print("NO USER ID IN USERDEFAULTS")
            throw URLError(.badServerResponse)
        }

        var components = URLComponents(string: baseURL + "/api/study/room")
        components?.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size))
        ]

        guard let url = components?.url else {
            print("BAD URL")
            throw URLError(.badURL)
        }

        print("REQUEST URL:", url.absoluteString)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse {
                print("STATUS CODE:", http.statusCode)
                print("HEADERS:", http.allHeaderFields)
            }

            let raw = String(data: data, encoding: .utf8) ?? "NO BODY"
            print("RAW BODY:", raw)

            guard let http = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard 200...299 ~= http.statusCode else {
                throw NSError(
                    domain: "BackendError",
                    code: http.statusCode,
                    userInfo: [
                        NSLocalizedDescriptionKey: raw
                    ]
                )
            }

            do {
                return try JSONDecoder().decode(StudyRoomPageResponse.self, from: data)
            } catch {
                print("DECODING ERROR:", error)
                print("RAW JSON:", raw)
                throw error
            }

        } catch {
            let nsError = error as NSError
            print("FINAL ERROR DOMAIN:", nsError.domain)
            print("FINAL ERROR CODE:", nsError.code)
            print("FINAL ERROR DESCRIPTION:", nsError.localizedDescription)
            print("FINAL ERROR USER INFO:", nsError.userInfo)
            throw error
        }
    }
    
    func addRoomToDataBase(room: StudyResponse) async throws -> StudyResponseStatus{
        
        guard let url = URL(string: baseURL + "/api/study/room/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(room)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("STATUS:", httpResponse.statusCode)
        }

        print("RESPONSE:", String(data: data, encoding: .utf8) ?? "no body")

        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(StudyResponseStatus.self, from: data)
    }
    
    func getRandomPublicRoom(completion: @escaping (Result<StudyResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/study/room/random-public") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let room = try JSONDecoder().decode(StudyResponse.self, from: data)
                completion(.success(room))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
