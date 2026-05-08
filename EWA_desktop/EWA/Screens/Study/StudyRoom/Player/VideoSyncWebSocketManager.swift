//
//  VideoSyncWebSocketManager.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import Foundation

final class VideoSyncWebSocketManager {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let session = URLSession(configuration: .default)
    
    private let roomId: String
    private let userId: String
    
    private let baseURL = Environment.current.webSocketURL
    
    var onEventReceived: ((VideoSyncEvent) -> Void)?
    
    init(roomId: String, userId: String) {
        self.roomId = roomId
        self.userId = userId
    }
    
    func connect() {
        guard let url = URL(string: Environment.current.webSocketURL) else {
            return
        }

        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()

        sendConnectFrame()
        listen()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func send(action: VideoSyncAction, currentTime: Double) {
        let event = VideoSyncEvent(
            roomId: roomId,
            userId: userId,
            action: action,
            currentTime: currentTime,
            sentAt: Date().timeIntervalSince1970
        )

        guard let data = try? JSONEncoder().encode(event),
              let json = String(data: data, encoding: .utf8)
        else {
            return
        }

        let frame = """
        SEND
        destination:/app/video/sync
        content-type:application/json

        \(json)\u{00}
        """

        sendRaw(frame)
    }
    
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let message):
                self.handle(message)
                self.listen()
                
            case .failure(let error):
                print("WebSocket receive error:", error)
            }
        }
    }
    
    private func sendConnectFrame() {
        let frame = "CONNECT\naccept-version:1.2\nheart-beat:10000,10000\n\n\u{00}"
        sendRaw(frame)
    }

    private func subscribeToRoom() {
        let destination = "/topic/room/\(roomId)/video"

        let frame = """
        SUBSCRIBE
        id:sub-\(roomId)
        destination:\(destination)

        \u{00}
        """

        sendRaw(frame)
    }

    private func sendRaw(_ text: String) {
        webSocketTask?.send(.string(text)) { error in
            if let error {
                print("WebSocket send error:", error)
            }
        }
    }
    
    private func handle(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):

            if text.starts(with: "CONNECTED") {
                subscribeToRoom()
                return
            }

            guard let json = extractJSON(from: text),
                  let data = json.data(using: .utf8),
                  let event = try? JSONDecoder().decode(VideoSyncEvent.self, from: data)
            else {
                print("Cannot decode STOMP message:", text)
                return
            }

            DispatchQueue.main.async {
                self.onEventReceived?(event)
            }

        default:
            break
        }
    }
    
    private func extractJSON(from stompMessage: String) -> String? {
        guard let range = stompMessage.range(of: "\n\n") else {
            return nil
        }

        var body = String(stompMessage[range.upperBound...])
        body = body.replacingOccurrences(of: "\u{00}", with: "")
        return body.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//https://www.youtube.com/watch?v=kJoPssfEnO8
