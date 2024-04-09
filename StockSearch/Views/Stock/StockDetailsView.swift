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
                                .font(.headline)
                            
                            HStack{
                                Text("You have 0 shares of \(ticker.uppercased()).\nStart trading!")
                                
                                Spacer()
                                
                                Button(action: {
                                    print("bought stock")
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
                                    }
                                    .padding(.init(top: -8, leading: 0, bottom: 0, trailing: 0))
                                }
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        
                        // Insights Section
                        VStack(alignment: .leading) {
                            Text("Insights")
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
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
