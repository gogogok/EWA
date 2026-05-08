//
//  StudyParticipantsApiClient.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import Foundation

final class StudyParticipantsApiClient {
    
    static let shared = StudyParticipantsApiClient()
    
    private let baseURL = Environment.current.baseURL
    
    private init() {}
    
    // MARK: - Join room
    func joinRoom(
        roomId: String,
        participant: StudyRoomParticipant,
        completion: @escaping (Bool) -> Void
    ) {
        
        guard let url = URL(
            string: baseURL + "/api/study/room/\(roomId)/participants/join"
        ) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(participant)
        } catch {
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            
            if let error {
                print("JOIN ROOM ERROR:", error)
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            
            completion(httpResponse.statusCode == 200)
            
        }.resume()
    }
    
    // MARK: - Get participants
    func getParticipants(
        roomId: String,
        completion: @escaping ([StudyRoomParticipant]) -> Void
    ) {
        
        guard let url = URL(
            string: baseURL + "/api/study/room/\(roomId)/participants"
        ) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error {
                print("GET PARTICIPANTS ERROR:", error)
                completion([])
                return
            }
            
            guard let data else {
                completion([])
                return
            }
            
            do {
                let participants = try JSONDecoder()
                    .decode([StudyRoomParticipant].self, from: data)
                
                completion(participants)
                
            } catch {
                print(error)
                completion([])
            }
            
        }.resume()
    }
    
    // MARK: - Leave room
    func leaveRoom(
        roomId: String,
        userId: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let url = URL(
            string: baseURL + "/api/study/room/\(roomId)/participants/\(userId)/leave"
        ) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error {
                print("LEAVE ROOM ERROR:", error)
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }

            completion(200...299 ~= httpResponse.statusCode)
        }.resume()
    }
}
