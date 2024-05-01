//
//  StockDetailsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct StockDetailsView: View {
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    @StateObject var stockViewModel: StockViewModel
    
    let ticker: String
    @State private var navigationTitle: String = ""
    @State private var showTradingView = false
    
    @State private var isShowingPopUp = false
    @State private var popUpText = ""
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    init(ticker: String) {
        self.ticker = ticker
        self._stockViewModel = StateObject(wrappedValue: StockViewModel())
    }
    
    var body: some View {
        ZStack {
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
                                    HStack {
                                        Text(stockData.info.name)
                                            .foregroundColor(Color.gray)
                                        
                                        Spacer()
                                        
                                        AsyncImageView(url: URL(string: stockData.info.logo), width: 42, height: 42)
//                                            .padding(.vertical, 10)
                                    }
                                    
                                    
                                    HStack (alignment: .bottom) {
                                        Text("$\(String(format: "%.2f", stockData.summary.current))")
                                            .font(.largeTitle)
                                            .fontWeight(.semibold)
                                        
                                        HStack {
                                            Image(systemName: stockData.summary.changePercentage > 0 ? "arrow.up.right" : "arrow.down.right")
                                            Text("$\(String(format: "%.2f", stockData.summary.change))")
                                            Text("(\(String(format: "%.2f", stockData.summary.changePercentage))%)")
                                        }
                                        .font(.title3)
                                        .foregroundStyle(getStockColor(stockViewModel.stockColor))
                                    }
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 15)
                                
                                TimeChartsView(stocktTicker: ticker.uppercased(), stockColor: stockViewModel.stockColor, price: stockData.hourlyHistory.price, volume: stockData.history.volume, ohlc: stockData.history.ohlc)
                                    .frame(width: 430, height: 500)
                                
                                
                                // Portfolio Section
                                VStack(alignment: .leading) {
                                    Text("Portfolio")
                                        .font(.title)
                                        .padding(.vertical, -5)
                                    
                                    HStack{
                                        if let portfolioStock = portfolioViewModel.portfolioInStock(forTicker: ticker) {
                                            VStack (alignment: .leading, spacing: 13) {
                                                Text("Shares Owned: \(portfolioStock.quantity)")
                                                Text("Avg. Cost / Share: $\(String(format: "%.2f", portfolioStock.averageCostPerShare))")
                                                Text("Total Cost: $\(String(format: "%.2f", portfolioStock.totalPurchaseCost))")
                                                
                                                HStack (spacing: 0) {
                                                    Text("Change: ")
                                                    
                                                    Text("$\(String(format: "%.2f", portfolioStock.change))")
                                                        .foregroundStyle(getStockColorGivenValue(for: portfolioStock.change))
                                                }
                                                
                                                HStack (spacing: 0) {
                                                    Text("Market Value: ")
                                                    
                                                    Text("$\(String(format: "%.2f", portfolioStock.marketValue))")
                                                        .foregroundStyle(getStockColorGivenValue(for: portfolioStock.change))
                                                }
                                            }
                                        } else {
                                            Text("You have 0 shares of \(ticker.uppercased()).\nStart trading!")
                                        }
                                        
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
                                    
                                    HStack (spacing: 20){
                                        HStack {
                                            Text("High Price:  ")
                                                .fontWeight(.bold)
                                            Text("$\(String(format: "%.2f", stockData.summary.high))")
                                        }
                                        HStack {
                                            Text("Open Price:  ")
                                                .fontWeight(.bold)
                                            Text("$\(String(format: "%.2f", stockData.summary.open))")
                                        }
                                    }
                                    .font(.system(size: 15))
                                    .padding(.top, 8)
                                    .padding(.bottom, 12)
                                    
                                    HStack (spacing: 20) {
                                        HStack {
                                            Text("Low Price:  ")
                                                .fontWeight(.bold)
                                            Text("$\(String(format: "%.2f", stockData.summary.low))")
                                        }
                                        HStack {
                                            Text("Prev. Close:  ")
                                                .fontWeight(.bold)
                                            Text("$\(String(format: "%.2f", stockData.summary.previousClose))")
                                        }
                                    }
                                    .font(.system(size: 15))
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 15)
                                
                                // About section
                                VStack(alignment: .leading) {
                                    Text("About")
                                        .font(.title)
                                    
                                    HStack (spacing: 20) {
                                        VStack(alignment: .leading) {
                                            Text("IPO Start Date:")
                                                .padding(.bottom, 3.5)
                                            Text("Industry:")
                                                .padding(.bottom, 3.5)
                                            Text("Webpage:")
                                                .padding(.bottom, 3.5)
                                            Text("Company Peers:")
                                                .padding(.bottom, 3.5)
                                        }
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(stockData.info.ipo)")
                                                .padding(.bottom, 3.5)
                                            Text("\(stockData.info.finnhubIndustry)")
                                                .padding(.bottom, 3.5)
                                            Button(action: {
                                                if let url = URL(string: stockData.info.weburl) {
                                                    UIApplication.shared.open(url)
                                                }
                                            }) {
                                                Text(stockData.info.weburl)
                                            }
                                            .foregroundColor(.blue)
                                            .padding(.bottom, 3.5)
                                            
                                            ScrollView(.horizontal,  content: {
                                                HStack (spacing: 0, content: {
                                                    ForEach(stockData.peers, id: \.self) { peer in
                                                        NavigationLink(destination: StockDetailsView(ticker: peer.lowercased())) {
                                                            Text("\(peer), ")
                                                                .foregroundColor(.blue)
                                                        }
                                                        .id(peer)
                                                        .onAppear {
                                                            self.navigationTitle = self.ticker.uppercased()
                                                        }
                                                    }
                                                })
                                            })
                                            .padding(.init(top: 0, leading: 0, bottom: 3.5, trailing: 0))
                                        }
                                        .font(.system(size: 15))
                                    }
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 15)
                                
                                // Insights Section
                                VStack(alignment: .leading) {
                                    Text("Insights")
                                        .font(.title)
                                    
                                    InsightsView(companyName: stockData.info.name, positiveMSPR: stockData.sentiment.positiveMSPR, negativeMSPR: stockData.sentiment.negativeMSPR, positiveChange: stockData.sentiment.positiveChange, negativeChange: stockData.sentiment.negativeChange)
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 15)
                                
                                // Recommendation Chart
                                RecommendationChartsView(
                                    strongBuy: stockData.recommendations.strongBuy,
                                    buy: stockData.recommendations.buy,
                                    hold: stockData.recommendations.hold,
                                    sell: stockData.recommendations.sell,
                                    strongSell: stockData.recommendations.strongSell,
                                    periods: stockData.recommendations.periods
                                )
                                
                                // EPS Chart (Optional width: 393)
                                EPSChartsView(
                                    periods: stockData.earnings.timePeriods,
                                    actual: stockData.earnings.actual,
                                    estimate: stockData.earnings.estimate
                                )
                                
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
                                    FavoriteToggleButton(ticker: ticker, companyName: stockData.info.name, isShowingPopUp: $isShowingPopUp, popUpText: $popUpText)
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
            
            if isShowingPopUp {
                AlertPopupView(alertText: popUpText)
                    .frame(height: 750)
            }
        }
    }
    
    func getStockColor(_ color: String) -> Color {
        switch color {
        case "green":
            return Color.green
        case "red":
            return Color.red
        case "black":
            return Color.black
        default:
            return Color.black
        }
    }
    func getStockColorGivenValue(for percentageChange: Double) -> Color {
        if percentageChange > 0 {
            return .green
        } else if percentageChange < 0 {
            return .red
        } else {
            return .black
        }
    }
}

struct FavoriteToggleButton: View {
    let ticker: String
    let companyName: String
    @EnvironmentObject var watchlistViewModel: WatchlistViewModel
    @Binding var isShowingPopUp: Bool
    @Binding var popUpText: String

    var isStockInWatchlist: Bool {
        return watchlistViewModel.checkStockInWatchlist(stock: self.ticker.uppercased())
    }
    
    var body: some View {
        Button(action: {
            if isStockInWatchlist {
                watchlistViewModel.removeFromWatchlist(stock: ticker.lowercased()) { success in
                    if success {
                        withAnimation {
                            isShowingPopUp = true
                            popUpText = "Removing \(ticker.uppercased()) to Favorites"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isShowingPopUp = false
                                }
                            }
                            print("Successfully removed to watchlist")
                        }
                        
                    }
                }
            } else {
                watchlistViewModel.addToWatchlist(stock: ticker.lowercased(), companyName: companyName) { success in
                    if success {
                        withAnimation {
                            isShowingPopUp = true
                            popUpText = "Adding \(ticker.uppercased()) to Favorites"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isShowingPopUp = false
                                }
                            }
                            print("Successfully added to watchlist")
                        }
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
