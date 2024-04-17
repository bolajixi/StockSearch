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
    @State private var quantityInput = ""
    @State private var calculatedTotalValue: Double = 0.0
    @FocusState private var isTextFieldActive: Bool
    
    @State private var isShowingTradingSuccess = false
    @State private var isShowingPopUp = false
    @State private var popUpText = "Please enter a valid amount"
    @State private var actionBinding: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                if isShowingTradingSuccess {
                    PortfolioTradingSuccessView(action: actionBinding, quantity: quantity ?? 0, ticker: ticker)
                        .transition(.opacity)
                        .animation(.default)
                } else {
                    VStack {
                        
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
                            TextField("0", text: $quantityInput)
                                .keyboardType(.default)
                                .font(.system(size: 90))
                                .frame(width: 125)
                                .background(Color.clear)
                                .padding(.horizontal, 10)
                                .focused($isTextFieldActive)
                                .onChange(of: quantityInput) {
                                    if quantityInput.isNumber {
                                        self.quantity = Int(quantityInput)
                                        
                                        if let quantity = quantity, quantity > 0 {
                                            self.calculatedTotalValue = currentStockPrice * Double(quantity)
                                        } else {
                                            self.calculatedTotalValue = 0.0
                                        }
                                    }
                                }
                            
                            Spacer()
                            
                            VStack (alignment: .trailing) {
                                Text("Share\(quantity ?? 0 > 1 ? "s" : "")")
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
                                                quantity: quantity ?? 875399945720117270,
                                                purchasePrice: currentStockPrice,
                                                isShowingTradingSuccess: $isShowingTradingSuccess,
                                                isShowingPopUp: $isShowingPopUp,
                                                popUpText: $popUpText,
                                                actionBinding: $actionBinding
                                    )
                                    
                                    Spacer()
                                    
                                    tradeButton(action: "Sell",
                                                portfolioViewModel: portfolioViewModel,
                                                ticker: ticker.lowercased(),
                                                companyName: companyName,
                                                quantity: quantity ?? 875399945720117270,
                                                sellPrice: currentStockPrice,
                                                isShowingTradingSuccess: $isShowingTradingSuccess,
                                                isShowingPopUp: $isShowingPopUp,
                                                popUpText: $popUpText,
                                                actionBinding: $actionBinding
                                    )
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .onAppear {
                        isTextFieldActive = false
                    }
                    .opacity(isShowingTradingSuccess ? 0 : 1)
                }
            }
            
            if isShowingPopUp {
                AlertPopupView(alertText: popUpText)
            }
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
    
    @Binding var isShowingTradingSuccess: Bool
    @Binding var isShowingPopUp: Bool
    @Binding var popUpText: String
    @Binding var actionBinding: String
    
    var body: some View {
        Button(action: {
            if action == "Buy" {
                if quantity == 875399945720117270 {
                    withAnimation {
                        isShowingPopUp = true
                        popUpText = "Please enter a valid amount"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingPopUp = false
                            }
                        }
                    }
                } else if quantity > 0 {
                    portfolioViewModel.buyStock(stock: ticker, companyName: companyName, quantity: quantity, purchasePrice: purchasePrice!) { success in
                        if success {
                            withAnimation {
                                isShowingTradingSuccess.toggle()
                                actionBinding = action
                            }
                            print("Successfully bought \(ticker.uppercased())")
                        } else {
                            print("Failed to buy stock")
                        }
                    }
                } else if quantity < 1 {
                    withAnimation {
                        isShowingPopUp = true
                        popUpText = "Cannot buy non-positive shares"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingPopUp = false
                            }
                        }
                    }
                }
            } else if action == "Sell" {
                if quantity == 875399945720117270 {
                    withAnimation {
                        isShowingPopUp = true
                        popUpText = "Please enter a valid amount"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingPopUp = false
                            }
                        }
                    }
                } else if quantity > 0 {
                    portfolioViewModel.sellStock(stock: ticker, quantity: quantity, sellPrice: sellPrice!) { success in
                        if success {
                            withAnimation {
                                isShowingTradingSuccess.toggle()
                                actionBinding = action
                            }
                            
                            print("Successfully sold \(ticker.uppercased())")
                        } else {
                            print("Failed to sell stock")
                        }
                    }
                } else if quantity < 1 {
                    withAnimation {
                        isShowingPopUp = true
                        popUpText = "Cannot sell non-positive shares"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingPopUp = false
                            }
                        }
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

// (Source): "https://sarunw.com/posts/how-to-check-if-string-is-number-in-swift/"
extension String {
    var isNumber: Bool {
        return self.range(
            of: "^-?[0-9]+$",
            options: .regularExpression) != nil
    }
}

#Preview {
    PortfolioTradingView(ticker: "AAPL", companyName: "Apple Inc", currentStockPrice: 171.58)
        .environmentObject(PortfolioViewModel())
}
