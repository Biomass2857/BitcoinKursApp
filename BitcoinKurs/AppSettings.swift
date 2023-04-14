//
//  AppSettings.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

final class AppSettings: ObservableObject {
    @AppStorage("currency") var currency: Currency = .euro
}
