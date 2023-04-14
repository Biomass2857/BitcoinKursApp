//
//  HTTPClient.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation

protocol HTTPClient {
    func fetch<T: Decodable>(request: URLRequest) async throws -> T
}
