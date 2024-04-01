//
//  ContentView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = StockViewModel()
    let ticker = "META"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Ticker: \(viewModel.stockDataResponse?.info.ticker ?? "")")
            
            Button("Fetch Data") {
                viewModel.fetchData(forTicker: ticker) { stockDataResponse in
                    if let stockDataResponse = stockDataResponse {
                        print(viewModel.stockDataResponse?.priceHistory)
                    } else {
                        print("Failed to fetch data")
                    }
                }
            }
        }
//        .onAppear {
//            viewModel.fetchData(forTicker: ticker)
//        }
        .padding()
    }
}

#Preview {
    ContentView()
}
