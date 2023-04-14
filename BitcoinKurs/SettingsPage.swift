//
//  SettingsPage.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

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
