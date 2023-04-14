//
//  Currency.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation

enum Currency: String, CaseIterable {
    case euro
    case dollar
    case pound
    case yen
    case franc
    
    var fullName: String {
        switch self {
        case .euro:
            return "Euro"
        case .dollar:
            return "Dollar"
        case .pound:
            return "Pfund"
        case .yen:
            return "Yen"
        case .franc:
            return "Schweizer Franken"
        }
    }
    
    var symbol: String {
        switch self {
        case .euro:
            return "€"
        case .dollar:
            return "$"
        case .franc:
            return "Fr."
        case .yen:
            return "¥"
        case .pound:
            return "£"
        }
    }
}
