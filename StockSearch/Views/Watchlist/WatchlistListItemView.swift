//
//  WatchlistListItemView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct WatchlistListItemView: View {
    let ticker: String
    let companyName: String
    let currentPrice: Double
    let change: Double
    let percentageChange: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(ticker)
                    .fontWeight(.bold)
                Text(companyName)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray.opacity(0.6))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(String(format: "%.2f", currentPrice))")
                    .fontWeight(.bold)
                HStack {
                    Image(systemName: percentageChange > 0 ? "arrow.up.right" : "arrow.down.right")
                    Text("$\(String(format: "%.2f", change))")
                    Text("(\(String(format: "%.2f", percentageChange))%)")
                }
                .foregroundStyle(getStockColor(for: percentageChange))
            }
        }
        .font(.system(size: 18))
        .padding(.top, 4.5)
        .padding(.bottom, 4.5)
    }
    
    func getStockColor(for percentageChange: Double) -> Color {
        if percentageChange > 0 {
            return .green
        } else if percentageChange < 0 {
            return .red
        } else {
            return .black
        }
    }
}

#Preview {
    WatchlistListItemView(ticker: "AAPL", companyName: "Apple Inc", currentPrice: 517.90, change: 0.19, percentageChange: 0.04)
}
