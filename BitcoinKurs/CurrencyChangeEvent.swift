//
//  CurrencyChangeEvent.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import Foundation

struct CurrencyChangeEvent: Identifiable {
    let date: Date
    let factor: Double
    
    var id: Double {
        date.timeIntervalSince1970
    }
}
