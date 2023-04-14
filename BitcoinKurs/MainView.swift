//
//  ContentView.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewViewModel = {
        let httpClient = DefaultHTTPClient()
        let service = CoinGeckoApiService(httpClient: httpClient)
        return MainViewViewModel(changeEventApiService: service)
    }()
    
    var body: some View {
        ChangeEventTable(
            changeEvents: viewModel.changeValues
        )
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}
