//
//  MainViewViewModel.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

final class MainViewViewModel: ObservableObject {
    @Published var changeValues: [CurrencyChangeEvent] = []
    @Published var lastUpdated: Date?
    @Published var errorString: String?
    
    private let changeEventApiService: CoinGeckoApiService
    
    init(changeEventApiService: CoinGeckoApiService) {
        self.changeEventApiService = changeEventApiService
    }
    
    private func refreshDataAndUpdate() async {
        do {
            let values = try await changeEventApiService.fetchBitcoinToEuro().reversed()
            
            DispatchQueue.main.async {
                self.changeValues = Array(values)
                self.lastUpdated = .now
            }
        } catch {
            DispatchQueue.main.async {
                self.errorString = "an error occured: \(error)"
            }
        }
    }
    
    func onRefresh() async {
        await refreshDataAndUpdate()
    }
    
    func onAppear() {
        Task {
            await refreshDataAndUpdate()
        }
    }
}
