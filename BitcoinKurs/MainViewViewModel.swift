//
//  MainViewViewModel.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

final class MainViewViewModel: ObservableObject {
    @Published var changeValues: [CurrencyChangeEvent] = []
    
    private let changeEventApiService: CoinGeckoApiService
    
    init(changeEventApiService: CoinGeckoApiService) {
        self.changeEventApiService = changeEventApiService
    }
    
    func onAppear() {
        Task {
            let values = try await changeEventApiService.fetchBitcoinToEuro().reversed()
            
            DispatchQueue.main.async {
                self.changeValues = Array(values)
            }
        }
    }
}
