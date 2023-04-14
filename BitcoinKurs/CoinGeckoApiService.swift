//
//  CoinGeckoApiService.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation

struct CoinGeckoApiService {
    private let httpClient: HTTPClient
    private let endpointURL = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    struct InvalidDataFormatError: Error {}
    struct InvalidEndpointURLError: Error {}
    
    func fetchBitcoinChangeValueBatch(
        currency: Currency = .euro
    ) async throws -> CurrencyChangeEventBatch {
        let request = try makeRequest(for: currency)
        let response: CoinGeckoChangeResponse = try await httpClient.fetch(request: request)
        let events = try convertToChangeEvents(response: response)
        
        let batch = CurrencyChangeEventBatch(
            lastUpdated: .now,
            currency: currency,
            changeEvents: events
        )
        
        return batch
    }
    
    private func getTickerString(for currency: Currency) -> String {
        switch currency {
        case .euro:
            return "eur"
        case .dollar:
            return "usd"
        case .pound:
            return "gbp"
        case .yen:
            return "jpy"
        case .franc:
            return "chf"
        }
    }
    
    private func makeRequest(for currency: Currency) throws -> URLRequest {
        guard let url = URL(string: endpointURL) else {
            throw InvalidEndpointURLError()
        }
        
        let queryItems = [
            URLQueryItem(name: "vs_currency", value: getTickerString(for: currency)),
            URLQueryItem(name: "days", value: "14"),
            URLQueryItem(name: "interval", value: "daily")
        ]
        
        let urlWithQuery = url.appending(queryItems: queryItems)
        
        return URLRequest(url: urlWithQuery)
    }
    
    private struct CoinGeckoChangeResponse: Decodable {
        let prices: [[Double]]
    }
    
    private func convertToChangeEvents(response: CoinGeckoChangeResponse) throws -> [CurrencyChangeEvent] {
        try response.prices.map { valuePair in
            guard valuePair.count == 2 else {
                throw InvalidDataFormatError()
            }
            
            let date = Date(timeIntervalSince1970: valuePair[0] / 1000)
            let factor = valuePair[1]
            
            return CurrencyChangeEvent(
                date: date,
                factor: factor
            )
        }
    }
}
