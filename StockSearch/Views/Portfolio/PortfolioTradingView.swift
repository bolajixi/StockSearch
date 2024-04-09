//
//  PortfolioTradingView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/9/24.
//

import SwiftUI

struct PortfolioTradingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    
    var ticker: String
    var companyName: String
    var currentStockPrice: Double

    @State private var quantity: Int?
    @State private var calculatedTotalValue: Double = 0.0
    @FocusState private var isTextFieldActive: Bool
    
    var body: some View {
        VStack {
//            Color.green // fill with green on buy or sell
//                .ignoresSafeArea(.all)
            
            HStack(content: {
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding(10)
                })
                .frame(width: 30, height: 30)
                .padding(.vertical, 12)
                .padding(.horizontal, 10)
            })
            
            Text("Trade \(companyName) shares")
                .fontWeight(.bold)
            
            Spacer()
            
            HStack {
                TextField("0", value: $quantity, formatter: NumberFormatter())
                    .font(.system(size: 90))
                    .frame(width: 160)
                    .background(Color.clear)
                    .padding(.horizontal, 10)
                    .focused($isTextFieldActive)
                    .onChange(of: quantity) {
                        print(quantity!)
                    }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Text("Share")
                        .font(.largeTitle)
                    .padding(.horizontal, 10)
                    
                    Text("x $\(String(format: "%.2f", currentStockPrice))/share = $\(String(format: "%.2f", calculatedTotalValue))")
                        .padding(.horizontal, 10)
                }
            }
            
            Spacer()
            
            VStack {
                if let portfolio = portfolioViewModel.portfolio {
                    Text("$\(String(format: "%.2f", portfolio.availableBalance)) available to buy \(ticker.uppercased())")
                        .foregroundColor(Color.gray.opacity(0.6))
                        .font(.subheadline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    HStack {
                        Spacer()
                        tradeButton(action: "Buy", 
                                    portfolioViewModel: portfolioViewModel,
                                    ticker: ticker.lowercased(),
                                    companyName: companyName,
                                    quantity: quantity ?? 0,
                                    purchasePrice: currentStockPrice)
                        
                        Spacer()
                        
                        tradeButton(action: "Sell",
                                    portfolioViewModel: portfolioViewModel,
                                    ticker: ticker.lowercased(),
                                    companyName: companyName,
                                    quantity: quantity ?? 0,
                                    sellPrice: currentStockPrice)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            isTextFieldActive = true
        }
    }
}

struct tradeButton: View {
    var action: String
    var portfolioViewModel: PortfolioViewModel
    
    var ticker: String
    var companyName: String
    var quantity: Int
    var purchasePrice: Double?
    var sellPrice: Double?
    
    var body: some View {
        Button(action: {
            if action == "Buy" {
                portfolioViewModel.buyStock(stock: ticker, companyName: companyName, quantity: quantity, purchasePrice: purchasePrice!) { success in
                if success {
                    print("Successfully bought \(ticker.uppercased())")
                } else {
                    print("Failed to buy stock")
                }
            }
            } else if action == "Sell" {
                portfolioViewModel.sellStock(stock: ticker, quantity: quantity, sellPrice: sellPrice!) { success in
                    if success {
                        print("Successfully sold \(ticker.uppercased())")
                    } else {
                        print("Failed to sell stock")
                    }
                }
            }
        }, label: {
            Text(action)
                .foregroundColor(.white)
                .padding()
        })
        .frame(width: 165)
        .background(Color.green)
        .cornerRadius(50)
    }
}

#Preview {
    PortfolioTradingView(ticker: "AAPL", companyName: "Apple Inc", currentStockPrice: 171.58)
        .environmentObject(PortfolioViewModel())
}
