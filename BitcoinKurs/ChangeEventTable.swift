//
//  ChangeEventTable.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

struct ChangeEventTable: View {
    let changeEvents: [CurrencyChangeEvent]
    let currency: Currency
    
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    private func formattedChangeValue(value: Double) -> String {
        String(format: "%.2f \(currency.symbol)", value)
    }
    
    var body: some View {
        List(changeEvents) { event in
            HStack {
                Text(formattedDate(date: event.date))
                Spacer()
                Text(formattedChangeValue(value: event.factor))
            }
        }
    }
}

struct ChangeEventTable_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEventTable(
            changeEvents: [
                CurrencyChangeEvent(
                    date: .now,
                    factor: 100
                ),
                CurrencyChangeEvent(
                    date: Date(timeIntervalSince1970: 0),
                    factor: 50
                )
            ],
            currency: .yen
        )
    }
}
