//
//  BitcoinKursApp.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

@main
struct BitcoinKursApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
                    .toolbar(.visible, for: .navigationBar)
                    .toolbar {
                        NavigationLink(
                            destination: SettingsPage(),
                            label: {
                                Label("Settings", systemImage: "gear")
                                    .foregroundColor(.accentColor)
                            }
                        )
                    }
            }
        }
    }
}
