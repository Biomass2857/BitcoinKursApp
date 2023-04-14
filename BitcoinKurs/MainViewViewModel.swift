//
//  MainViewViewModel.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

final class MainViewViewModel: ObservableObject {
    @Published var changeBatch: CurrencyChangeEventBatch?
    @Published var errorString: String?
    @Published var isLoading: Bool = false
    
    private let updateInterval: TimeInterval = 10
    private var timer: Timer?
    private let changeEventApiService: CoinGeckoApiService
    private let changeEventPersistentStorage: CurrencyChangeEventStorage
    private let appSettings = AppSettings()
    
    init(
        changeEventApiService: CoinGeckoApiService,
        changeEventPersistentStorage: CurrencyChangeEventStorage
    ) {
        self.changeEventApiService = changeEventApiService
        self.changeEventPersistentStorage = changeEventPersistentStorage
    }
    
    var selectedCurrency: Currency {
        appSettings.currency
    }
    
    func onRefresh() async {
        await refreshData()
        
        DispatchQueue.main.async {
            self.rescheduleContinousRefresh()
        }
    }
    
    func onAppear() {
        initialLoadOfData()
        
        DispatchQueue.main.async {
            self.rescheduleContinousRefresh()
        }
    }
    
    private func initialLoadOfData() {
        Task {
            await refreshData()
        }
        
        do {
            let persistentStorageBatch = try changeEventPersistentStorage.loadBatch()
            
            DispatchQueue.main.async {
                self.changeBatch = persistentStorageBatch
            }
        } catch let error {
            DispatchQueue.main.async {
                self.errorString = "\(error)"
            }
        }
    }
    
    private func rescheduleContinousRefresh() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.refreshData()
            }
        }
    }
    
    private func refreshData() async {
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let selectedCurrency = appSettings.currency
            
            let batch = try await changeEventApiService.fetchBitcoinChangeValueBatch(
                currency: selectedCurrency
            )
            
            changeEventPersistentStorage.saveBatch(batch: batch)
            
            DispatchQueue.main.async {
                self.changeBatch = batch
            }
        } catch {
            DispatchQueue.main.async {
                self.errorString = "an error occured: \(error)"
            }
        }
    }
}
