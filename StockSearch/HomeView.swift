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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Ticker: \(stockViewModel.stockDataResponse?.info.ticker ?? "")")
            
            Button("Fetch Stock Data") {
                stockViewModel.fetchData(forTicker: ticker) { stockDataResponse in
                    if stockDataResponse != nil {
                        print(stockViewModel.stockDataResponse!)
                    } else {
                        print("Failed to fetch data")
                    }
                }
            }
            Button("Fetch Watchlist") {
                watchlistViewModel.fetchWatchlist { watchlist in
                    if watchlist != nil {
                        print(watchlistViewModel.watchlist!)
                    } else {
                        print("Failed to fetch watchlist")
                    }
                }
            }
            
            Button("Add to Watchlist") {
                watchlistViewModel.addToWatchlist(stock: ticker, companyName: companyName) { success in
                    if success {
                        print("Successfully added to watchlist")
                        print(watchlistViewModel.watchlist!)
                    } else {
                        print("Failed to add to watchlist")
                    }
                }
            }
            
            Button("Remove from Watchlist") {
                watchlistViewModel.removeFromWatchlist(stock: ticker, companyName: companyName) { success in
                    if success {
                        print("Successfully removed to watchlist")
                        print(watchlistViewModel.watchlist!)
                    } else {
                        print("Failed to add to watchlist")
                    }
                }
            }
            
            Button("Fetch Portfolio") {
                portfolioViewModel.fetchPortfolio { portfolio in
                    if portfolio != nil {
                        print(portfolioViewModel.portfolio!)
                    } else {
                        print("Failed to fetch portfolio")
                    }
                }
            }
            
            Button("Buy Stock") {
                portfolioViewModel.buyStock(stock: ticker, companyName: companyName, quantity: quantity, purchasePrice: purchasePrice) { success in
                    if success {
                        print("Successfully bought stock")
                    } else {
                        print("Failed to buy stock")
                    }
                }
            }
            
            Button("Sell Stock") {
                portfolioViewModel.sellStock(stock: ticker, quantity: quantity, sellPrice: sellPrice) { success in
                    if success {
                        print("Successfully sold stock")
                    } else {
                        print("Failed to sell stock")
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
    HomeView()
}
