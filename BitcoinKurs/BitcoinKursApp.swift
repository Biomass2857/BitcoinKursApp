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
            MainView(viewModel: mainViewViewModel)
        }
    }
    
    private var mainViewViewModel: MainViewViewModel {
        let httpClient = DefaultHTTPClient()
        let service = CoinGeckoApiService(httpClient: httpClient)
        return MainViewViewModel(changeEventApiService: service)
    }
}
