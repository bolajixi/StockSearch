//
//  ContentView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var watchlistViewModel: WatchlistViewModel
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel

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
                    if let portfolio = portfolioViewModel.portfolio {
                        PortfolioDetailsView(netWorth: portfolioViewModel.netWorth, cashBalance:portfolio.availableBalance)
                        
                        ForEach(portfolio.stocks) { stock in
                            NavigationLink(destination: StockDetailsView(ticker: stock.symbol.lowercased())) {
                                PortfolioListItemView(ticker: stock.symbol.uppercased(), quantity: stock.quantity, totalPurchaseCost: stock.totalPurchaseCost, change: 0.19, percentageChange: 0.04)
                            }
                        }
                        .onMove(perform: moveItemPortfolio)
                    } else {
                        ProgressView()
                    }
                } header: {
                    Text("Portfolio")
                }
                
                Section {
                    if let watchlist = watchlistViewModel.watchlist {
                        
                        ForEach(watchlist.stocks) { stock in
                            NavigationLink(destination: StockDetailsView(ticker: stock.ticker.lowercased())) {
                                WatchlistListItemView(ticker: stock.ticker, companyName: stock.companyName, currentPrice: stock.currentPrice, change: stock.priceChange, percentageChange: stock.priceChangePercentage)
                            }
                        }
                        .onDelete(perform: removeFavorite)
                        .onMove(perform: moveItemWatchlist)
                    } else {
                        ProgressView()
                    }
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
    
    func removeFavorite(at offsets: IndexSet){
        guard let watchlist = watchlistViewModel.watchlist else { return }
            
        let symbolsToDelete = offsets.map { watchlist.stocks[$0].ticker }
        
        for symbol in symbolsToDelete {
            watchlistViewModel.removeFromWatchlist(stock: symbol.lowercased()) { success in
                if success {
                    print("\(symbol.uppercased()) removed from watchlist")
                } else {
                    print("Error  removing \(symbol.uppercased()) from watchlist")
                }
            }
        }
    }
    
    func moveItemWatchlist(from: IndexSet, to: Int){
        watchlistViewModel.watchlist?.stocks.move(fromOffsets: from, toOffset: to)
    }
    
    func moveItemPortfolio(from: IndexSet, to: Int){
        portfolioViewModel.portfolio?.stocks.move(fromOffsets: from, toOffset: to)
    }
}

#Preview {
    HomeView()
        .environmentObject(WatchlistViewModel())
        .environmentObject(PortfolioViewModel())
}
