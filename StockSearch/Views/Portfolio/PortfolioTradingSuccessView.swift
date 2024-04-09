//
//  PortfolioTradingSuccessView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/9/24.
//

import SwiftUI

struct PortfolioTradingSuccessView: View {
    var action: String
    var quantity: Int
    var ticker: String
    
    var body: some View {
        let actionText = action == "Buy" ? "bought" : "sold"
        
        ZStack {
            Color.green
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.white)
                
                Text("You have successfully \(actionText) \(quantity) shares of \(ticker.uppercased())")

                    .foregroundStyle(.white)
                    .padding()
                
                Spacer()
                
                CloseSuccessButton()
            }
        }
    }
}

struct CloseSuccessButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Done")
                .foregroundColor(.green)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
        })
        .frame(width: 330)
        .background(Color.white)
        .cornerRadius(50)
    }
}

#Preview {
    PortfolioTradingSuccessView(action: "Buy", quantity: 3, ticker: "AAPL")
}
