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
        let persistentStorage = CurrencyChangeEventStorage.shared
        return MainViewViewModel(
            changeEventApiService: service,
            changeEventPersistentStorage: persistentStorage
        )
    }()
    
    private var lastUpdatedString: String? {
        guard let lastUpdatedDate = viewModel.changeBatch?.lastUpdated else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        
        guard let dateString = formatter.string(for: lastUpdatedDate) else {
            return nil
        }
        
        return "letzte Aktualisierung: " + dateString
    }
    
    var body: some View {
        VStack {
            if let errorString = viewModel.errorString {
                Text(errorString)
                    .foregroundColor(.red)
            }
            HStack {
                Text("Bitcoin Value")
                    .font(.largeTitle)
                Spacer()
            }
            HStack {
                if let lastUpdatedString {
                    Text(lastUpdatedString)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.leading, 16)
                }
                Spacer()
            }
            if let changeBatch = viewModel.changeBatch {
                ChangeEventTable(
                    changeEvents: changeBatch.changeEvents,
                    currency: changeBatch.currency
                )
                .refreshable {
                    await viewModel.onRefresh()
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}
