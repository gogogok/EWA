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
            return "http://127.0.0.1:10000"
        case .production:
            return "https://ewa-pk7o.onrender.com"
        }
    }
}
