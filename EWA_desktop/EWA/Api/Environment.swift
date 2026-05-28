//
//  Environment.swift
//  EWA
//
//  Created by Дарья Жданок on 13.04.26.
//

enum Environment {
    case local
    case production
    
    static let current: Environment = .local

    var baseURL: String {
        switch self {
        case .local:
            
            return "http://localhost:10000"
        case .production:
            return "https://ewa-pk7o.onrender.com"
        }
    }
    
    var webSocketURL: String {
        switch self {
        case .local:
            return "ws://localhost:10000/ws"
            
        case .production:
            return "wss://ewa-pk7o.onrender.com/ws"
        }
    }
}
