//
//  StockDetailsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct StockDetailsView: View {
    @EnvironmentObject var stockViewModel: StockViewModel
    let ticker: String = "AAPL"
    
    var body: some View {
        Group {
            if stockViewModel.stockDataResponse != nil {
                Text("Stock data fetched for \(ticker)")
            } else if stockViewModel.isLoading {
                ProgressView()
                Text("Fetching Data...")
                    .foregroundColor(Color.gray)
            } else {
                Text("Failed to fetch data for \(ticker)")
            }
        }
        .onAppear {
            stockViewModel.fetchData(forTicker: ticker) { _ in }
        }
    }
}

#Preview {
    StockDetailsView()
        .environmentObject(StockViewModel())
}
