//
//  StockDetailsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct StockDetailsView: View {
    @StateObject var stockViewModel: StockViewModel
    
    let ticker: String
    @State private var navigationTitle: String = ""
    @State private var showTradingView = false
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    init(ticker: String) {
        self.ticker = ticker
        self._stockViewModel = StateObject(wrappedValue: StockViewModel())
    }
    
    var body: some View {
        Group {
            if stockViewModel.isLoading {
                VStack {
                    ProgressView()
                    Text("Fetching Data...")
                        .foregroundColor(Color.gray)
                }
            } else if let stockData = stockViewModel.stockDataResponse {
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(stockData.info.name)
                            
                            HStack {
                                Text("$\(String(format: "%.2f", stockData.summary.current))")
                                Text("$\(String(format: "%.2f", stockData.summary.change))")
                                Text("(\(String(format: "%.2f", stockData.summary.changePercentage))%)")
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        
                        // Portfolio Section
                        VStack(alignment: .leading) {
                            Text("Portfolio")
                                .font(.title)
                                .padding(.vertical, -5)
                            
                            HStack{
                                Text("You have 0 shares of \(ticker.uppercased()).\nStart trading!")
                                
                                Spacer()
                                
                                Button(action: {
                                    showTradingView.toggle()
                                }, label: {
                                    Text("Trade")
                                        .foregroundColor(.white)
                                        .padding()
                                })
                                .frame(width: 120)
                                .background(Color.green)
                                .cornerRadius(50)
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        
                        // Stats section
                        VStack(alignment: .leading) {
                            Text("Stats")
                                .font(.title)
                            
                            HStack{
                                Text("High Price:   $\(String(format: "%.2f", stockData.summary.high))")
                                Text("Open Price:   $\(String(format: "%.2f", stockData.summary.open))")
                            }
                            HStack{
                                Text("Low Price:    $\(String(format: "%.2f", stockData.summary.low))")
                                Text("Prev. Close:  $\(String(format: "%.2f", stockData.summary.previousClose))")
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        
                        // About section
                        VStack(alignment: .leading) {
                            Text("About")
                                .font(.title)
                            
                            HStack{
                                VStack(alignment: .leading) {
                                    Text("IPO Start Date:")
                                    Text("Industry:")
                                    Text("Webpage:")
                                    Text("Company Peers:")
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(stockData.info.ipo)")
                                    Text("\(stockData.info.finnhubIndustry)")
                                    Button(action: {
                                        if let url = URL(string: stockData.info.weburl) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        Text(stockData.info.weburl)
                                    }
                                    .foregroundColor(.blue)
                                    
                                    ScrollView(.horizontal,  content: {
                                        HStack (spacing: 0, content: {
                                            ForEach(stockData.peers, id: \.self) { peer in
                                                NavigationLink(destination: StockDetailsView(ticker: peer.lowercased())) {
                                                    Text("\(peer), ")
                                                        .foregroundColor(.blue)
                                                }
                                                .id(UUID())
                                                .onAppear {
                                                    self.navigationTitle = self.ticker.uppercased()
                                                }

                                            }
                                        })
                                    })
                                    .padding(.init(top: -8, leading: 0, bottom: 0, trailing: 0))
                                }
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        
                        // Insights Section
                        VStack(alignment: .leading) {
                            Text("Insights")
                                .font(.title)
                            
//                            InsightsView()
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        
                        // Latest News Section
                        VStack(alignment: .leading) {
                            Text("News")
                                .font(.title)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 0)
                            LatestNewsView(newsItems: stockData.latestNews)
                                .padding(.vertical, -30)
                        }
                        
                    }
                    .navigationTitle(navigationTitle)
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing) {
                            FavoriteToggleButton(ticker: ticker, companyName: stockData.info.name)
                        }
                    }
                    .sheet(isPresented: $showTradingView) {
                        PortfolioTradingView(ticker: ticker, companyName: stockData.info.name, currentStockPrice: stockData.summary.current)
                    }
                }
            } else {
                Text("Failed to fetch data for \(ticker)")
            }
        }
        .onAppear {
            if stockViewModel.stockDataResponse == nil {
                stockViewModel.fetchData(forTicker: ticker) { _ in }
            }
        }
    }
}

struct FavoriteToggleButton: View {
    let ticker: String
    let companyName: String
    @EnvironmentObject var watchlistViewModel: WatchlistViewModel

    var isStockInWatchlist: Bool {
        return watchlistViewModel.checkStockInWatchlist(stock: self.ticker.uppercased())
    }
    
    var body: some View {
        Button(action: {
            if isStockInWatchlist {
                watchlistViewModel.removeFromWatchlist(stock: ticker.lowercased()) { success in
                    if success {
                        print("Successfully removed to watchlist")
                    }
                }
            } else {
                watchlistViewModel.addToWatchlist(stock: ticker.lowercased(), companyName: companyName) { success in
                    if success {
                        print("Successfully added to watchlist")
                    }
                }
            }
        }) {
            Image(systemName: isStockInWatchlist ? "plus.circle.fill" : "plus.circle")
                .font(.headline)
        }
    }
}

#Preview {
    StockDetailsView(ticker: "AAPL")
        .environmentObject(PortfolioViewModel())
}
