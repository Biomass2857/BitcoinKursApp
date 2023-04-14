//
//  DefaultHTTPClient.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation

struct DefaultHTTPClient: HTTPClient {
    struct MissingDataError: Error {}
    
    func fetch<T>(request: URLRequest) async throws -> T where T : Decodable {
        try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let data {
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(with: .success(object))
                        return
                    } catch {
                        continuation.resume(throwing: error)
                        return
                    }
                }
                
                continuation.resume(throwing: MissingDataError())
            }
            
            task.resume()
        }
    }
}
