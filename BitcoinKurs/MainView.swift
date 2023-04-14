//
//  ContentView.swift
//  BitcoinKurs
//
//  Created by Tom Reinhardt on 14.04.23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewViewModel
    
    var body: some View {
        ChangeEventTable(
            changeEvents: viewModel.changeValues
        )
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}
