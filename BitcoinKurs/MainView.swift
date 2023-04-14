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
    
    private var lastUpdatedString: String? {
        guard let lastUpdatedDate = viewModel.lastUpdated else {
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
            if let lastUpdatedString {
                HStack {
                    Spacer()
                    Text(lastUpdatedString)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            ChangeEventTable(
                changeEvents: viewModel.changeValues,
                currency: viewModel.selectedCurrency
            )
        }
        .padding()
        .refreshable {
            await viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
