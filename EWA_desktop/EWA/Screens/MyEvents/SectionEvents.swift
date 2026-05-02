//
//  Section.swift
//  EWA
//
//  Created by Дарья Жданок on 16.04.26.
//

private enum SectionEvents: Int, CaseIterable {
    case created
    case registered
    
    var title: String {
        switch self {
        case .created:
            return "Мои запросы"
        case .registered:
            return "Принятые запросы"
        }
    }
}
