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
    @State private var navigationTitle: String = ""
    
    var body: some View {
        Group {
            if stockViewModel.isLoading {
                VStack{
                    ProgressView()
                    Text("Fetching Data...")
                        .foregroundColor(Color.gray)
                }
            } else if let stockData = stockViewModel.stockDataResponse {
                ScrollView {
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
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        
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
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(stockData.peers, id: \.self) { peer in
                                            NavigationLink(destination: StockDetailsView(ticker: peer.lowercased())) {
                                                Text("\(peer), ")
                                                    .foregroundColor(.blue)
                                            }
                                            .onAppear {
                                                self.navigationTitle = self.ticker.uppercased()
                                            }

                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        
                        // Insights Section
                        VStack(alignment: .leading) {
                            Text("insights")
                        }
                    }
                    .navigationTitle(navigationTitle)
                    }
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
