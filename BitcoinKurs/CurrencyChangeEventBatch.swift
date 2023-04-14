//
//  CurrencyChangeEventBatch.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation

struct CurrencyChangeEventBatch {
    let lastUpdated: Date
    let currency: Currency
    let changeEvents: [CurrencyChangeEvent]
}
