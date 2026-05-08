//
//  ChatWebSocketManager.swift
//  EWA
//
//  Created by Дарья Жданок on 6.05.26.
//

import Foundation
import Starscream

final class ChatWebSocketManager: WebSocketDelegate {

    private let roomId: String
    private let userId: String
    private let username: String

    private var socket: WebSocket?
    
    private let baseUrl = Environment.current.webSocketURL

    var onMessageReceived: ((ChatMessage) -> Void)?

    init(roomId: String, userId: String, username: String) {
        self.roomId = roomId
        self.userId = userId
        self.username = username
    }

    func connect() {
        guard let url = URL(string: baseUrl) else {
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10

        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
        socket = nil
    }

    func send(text: String) {
        let message = ChatMessage(
            roomId: roomId,
            userId: userId,
            username: username,
            text: text,
            createdAt: nil
        )

        guard let data = try? JSONEncoder().encode(message),
              let json = String(data: data, encoding: .utf8) else {
            return
        }

        let frame = """
        SEND
        destination:/app/chat.send
        content-type:application/json

        \(json)\u{00}
        """

        socket?.write(string: frame)
    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {

        case .connected:
            sendConnectFrame()
            subscribeToRoom()

        case .text(let text):
            handleIncomingText(text)

        case .error(let error):
            print("Chat WebSocket error:", error as Any)

        case .disconnected(let reason, let code):
            print("Chat disconnected:", reason, code)

        default:
            break
        }
    }

    private func sendConnectFrame() {
        let frame = """
        CONNECT
        accept-version:1.2
        host:localhost

        \u{00}
        """

        socket?.write(string: frame)
    }

    private func subscribeToRoom() {
        let frame = """
        SUBSCRIBE
        id:chat-\(roomId)
        destination:/topic/rooms/\(roomId)

        \u{00}
        """

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.socket?.write(string: frame)
        }
    }

    private func handleIncomingText(_ text: String) {
        guard let jsonStart = text.firstIndex(of: "{") else {
            return
        }

        let jsonString = String(text[jsonStart...])
            .replacingOccurrences(of: "\u{00}", with: "")

        guard let data = jsonString.data(using: .utf8),
              let message = try? JSONDecoder().decode(ChatMessage.self, from: data) else {
            return
        }

        DispatchQueue.main.async {
            self.onMessageReceived?(message)
        }
    }
}
