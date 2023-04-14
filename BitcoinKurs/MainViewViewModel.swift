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
    
    private let updateInterval: TimeInterval = 10
    private var timer: Timer?
    private let changeEventApiService: CoinGeckoApiService
    private let appSettings = AppSettings()
    
    init(changeEventApiService: CoinGeckoApiService) {
        self.changeEventApiService = changeEventApiService
    }
    
    var selectedCurrency: Currency {
        appSettings.currency
    }
    
    func onRefresh() async {
        await refreshDataAndUpdate()
        
        DispatchQueue.main.async {
            self.rescheduleContinousRefresh()
        }
    }
    
    func onAppear() {
        Task {
            await refreshDataAndUpdate()
        }
        
        DispatchQueue.main.async {
            self.rescheduleContinousRefresh()
        }
    }
    
    private func rescheduleContinousRefresh() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.refreshDataAndUpdate()
            }
        }
    }
    
    private func convertToCoinGeckoCurrency(currency: Currency) -> CoinGeckoApiService.CoinGeckoCurrency {
        switch currency {
        case .euro:
            return .euro
        case .dollar:
            return .dollar
        case .pound:
            return .pound
        case .yen:
            return .yen
        case .franc:
            return .franc
        }
    }
    
    private func refreshDataAndUpdate() async {
        do {
            let selectedCurrency = appSettings.currency
            let currencyToFetch = convertToCoinGeckoCurrency(currency: selectedCurrency)
            let values = try await changeEventApiService.fetchBitcoinToCurrencyChangeEvents(
                currency: currencyToFetch
            )
            
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
}
