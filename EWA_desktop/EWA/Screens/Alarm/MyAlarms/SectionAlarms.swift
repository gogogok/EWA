//
//  SectionAlarms.swift
//  EWA
//
//  Created by Дарья Жданок on 16.04.26.
//
import Foundation

enum SectionAlarms: Int, CaseIterable {
    case created
    case registered
    
    var title: String {
        switch self {
        case .created:
            return "Разбудить меня"
        case .registered:
            return "Нужно разбудить"
        }
    }
}
