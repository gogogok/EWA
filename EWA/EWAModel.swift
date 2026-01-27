//
//  EWAModel.swift
//  EWA
//
//  Created by Дарья Жданок on 26.01.26.
//

final class EWAModel {
    
    enum GetEmail {
        struct Request {
            var email: String
        }
        struct Response {
            var email: String
        }
        struct ViewModel {}
    }
}
