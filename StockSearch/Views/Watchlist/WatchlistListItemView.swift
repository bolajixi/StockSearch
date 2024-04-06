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
                HStack {
                    Text("$\(String(format: "%.2f", change))")
                    Text("(\(String(format: "%.2f", percentageChange))%)")
                }
            }
        }
        .font(.system(size: 18))
        .padding(.top, 4.5)
        .padding(.bottom, 4.5)
    }
}

#Preview {
    WatchlistListItemView(ticker: "AAPL", companyName: "Apple Inc", currentPrice: 517.90, change: 0.19, percentageChange: 0.04)
}
