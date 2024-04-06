//
//  ContentView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var stockViewModel = StockViewModel()
    @StateObject var watchlistViewModel = WatchlistViewModel()
    @StateObject var portfolioViewModel = PortfolioViewModel()
    let ticker = "META"
    let companyName = "Meta Platforms Inc"
    let quantity = 2
    let purchasePrice = 169.58
    let sellPrice = 169.58
    
    @State private var searchTerm: String = ""
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    let websiteURL = URL(string: "https://finnhub.io")!
    
    var body: some View {
        NavigationView {
            List {
                Text("\(dateFormatter.string(from: Date()))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                
                Section {
                    PortfolioDetailsView(netWorth: 25001.51, cashBalance: 14101.04)
                    PortfolioListItemView(ticker: "AAPL", quantity: 3, totalPurchaseCosr: 517.90, change: 0.19, percentageChange: 0.04)
                    PortfolioListItemView(ticker: "NVDA", quantity: 11, totalPurchaseCosr: 10382.57, change: 1.32, percentageChange: 0.01)
                } header: {
                    Text("Portfolio")
                }
                
                Section {
                    WatchlistListItemView(ticker: "AAPL", companyName: "Apple Inc", currentPrice: 172.63, change: 1.26, percentageChange: 0.74)
                    WatchlistListItemView(ticker: "QCOM", companyName: "Qualcomm Inc", currentPrice: 171.26, change: 0.41, percentageChange: 0.24)
                } header: {
                    Text("Favorites")
                }
                
                Button(action: {
                    UIApplication.shared.open(websiteURL)
                }) {
                    Text("Powered by Finnhub.io")
                        .foregroundColor(Color.gray.opacity(0.6))
                        .font(.headline)
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .searchable(text: $searchTerm)
            .navigationTitle("Stocks")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func removeFavorite(indecSet: IndexSet){
        
    }
}

#Preview {
    HomeView()
}
