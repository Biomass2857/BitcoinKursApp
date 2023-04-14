//
//  CoinGeckoApiService.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation

struct CurrencyChangeEvent {
    let date: Date
    let factor: Double
}

protocol HTTPClient {
    func fetch<T: Decodable>(request: URLRequest) async throws -> T
}

struct DefaultHTTPClient: HTTPClient {
    struct MissingDataError: Error {}
    
    func fetch<T>(request: URLRequest) async throws -> T where T : Decodable {
        try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let data {
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(with: .success(object))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
                
                continuation.resume(throwing: MissingDataError())
            }
            
            task.resume()
        }
    }
}

struct CoinGeckoApiService {
    private let httpClient: HTTPClient
    private let endpointURL = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    struct InvalidDataFormatError: Error {}
    struct InvalidEndpointURLError: Error {}
    
    func fetchBitcoinToEuro() async throws -> [CurrencyChangeEvent] {
        let request = try makeRequest()
        let response: CoinGeckoChangeResponse = try await httpClient.fetch(request: request)
        let result = try convertToChangeEvents(response: response)
        return result
    }
    
    private func makeRequest() throws -> URLRequest {
        guard let url = URL(string: endpointURL) else {
            throw InvalidEndpointURLError()
        }
        
        let queryItems = [
            URLQueryItem(name: "vs_currency", value: "eur"),
            URLQueryItem(name: "days", value: "1"),
            URLQueryItem(name: "interval", value: "weekly")
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
            
            let date = Date(timeIntervalSince1970: valuePair[0])
            let factor = valuePair[1]
            
            return CurrencyChangeEvent(
                date: date,
                factor: factor
            )
        }
    }
}
