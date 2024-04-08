//
//  StockDetailsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct StockDetailsView: View {
    @EnvironmentObject var stockViewModel: StockViewModel
    
    let ticker: String
    
    var body: some View {
        Group {
            if let stockData = stockViewModel.stockDataResponse {
                VStack(alignment: .leading) {
                    Text(stockData.info.name)
                    
                    HStack {
                        Text("$\(String(format: "%.2f", stockData.summary.current))")
                        Text("$\(String(format: "%.2f", stockData.summary.change))")
                        Text("(\(String(format: "%.2f", stockData.summary.changePercentage))%)")
                    }
                    
                    // Portfolio Section
                    VStack(alignment: .leading) {
                        Text("Portfolio")
                            .font(.headline)
                        
                        HStack{
                            Text("You have 0 shares of \(ticker.uppercased()).\nStart trading!")
                            
                            Button(action: {
                                print("bought stock")
                            }, label: {
                                Text("Trade")
                            })
                        }
                    }
                    
                    // Stats section
                    VStack(alignment: .leading) {
                        Text("Stats")
                        
                        HStack{
                            Text("High Price: $\(String(format: "%.2f", stockData.summary.high))")
                            Text("Open Price: $\(String(format: "%.2f", stockData.summary.open))")
                        }
                        HStack{
                            Text("Low Price: $\(String(format: "%.2f", stockData.summary.low))")
                            Text("Prev. Close: $\(String(format: "%.2f", stockData.summary.previousClose))")
                        }
                    }
                    
                    // About section
                    VStack(alignment: .leading) {
                        Text("About")
                        
                        Text("IPO Start Date: \(stockData.info.ipo)")
                        Text("Industry: \(stockData.info.finnhubIndustry)")
                        Text("Webpage: \(stockData.info.weburl)")
                        HStack {
                            Text("Peers: ")
                            ScrollView(.horizontal) {
                                ForEach(stockData.peers, id: \.self) { peer in
                                    Text(peer)
                                        .underline()
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            if let url = URL(string: peer) {
                                                UIApplication.shared.open(url)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    // Insights Section
                    VStack(alignment: .leading) {
                        Text("insights")
                    }
                }
                .navigationTitle(ticker.uppercased())
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
    StockDetailsView(ticker: "AAPL")
        .environmentObject(StockViewModel())
}
