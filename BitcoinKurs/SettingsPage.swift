//
//  SettingsPage.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

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

struct SettingsPage: View {
    @StateObject private var appSettings = AppSettings()
    
    var body: some View {
        Form {
            Picker(selection: $appSettings.currency, label: Text("Währung")) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.fullName)
                }
            }
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
