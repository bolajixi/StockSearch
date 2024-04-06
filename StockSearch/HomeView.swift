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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Ticker: \(stockViewModel.stockDataResponse?.info.ticker ?? "")")
            
            Button("Fetch Stock Data") {
                stockViewModel.fetchData(forTicker: ticker) { stockDataResponse in
                    if let stockDataResponse = stockDataResponse {
                        print(stockViewModel.stockDataResponse!)
                    } else {
                        print("Failed to fetch data")
                    }
                }
            }
            Button("Fetch Watchlist") {
                watchlistViewModel.fetchWatchlist { watchlist in
                    if let watchlist = watchlist {
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
                    if let portfolio = portfolio {
                        print(portfolioViewModel.portfolio!)
                    } else {
                        print("Failed to fetch portfolio")
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
