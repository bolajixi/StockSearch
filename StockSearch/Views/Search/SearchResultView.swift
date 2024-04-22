//
//  SearchResultView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/21/24.
//

import SwiftUI

struct SearchResultView: View {
    var autocompleteData: [AutoCompleteResult]
    
    var body: some View {
//        NavigationView{
            List {
                ForEach(autocompleteData) { result in
                    NavigationLink(destination: StockDetailsView(ticker: result.symbol.lowercased())) {
                        SearchRowView2(ticker: result.symbol, companyName: result.description)
                    }
                }
            }
//        }
    }
}

#Preview {
    SearchResultView(autocompleteData: [
        AutoCompleteResult(description: "Apple Inc", displaySymbol: "AAPL", symbol: "AAPL", type: "Common Stock"),
        AutoCompleteResult(description: "Microsoft Corporation", displaySymbol: "MSFT", symbol: "MSFT", type: "Common Stock"),
        AutoCompleteResult(description: "Amazon.com Inc", displaySymbol: "AMZN", symbol: "AMZN", type: "Common Stock"),
        AutoCompleteResult(description: "Alphabet Inc", displaySymbol: "GOOGL", symbol: "GOOGL", type: "Common Stock"),
        AutoCompleteResult(description: "Tesla Inc", displaySymbol: "TSLA", symbol: "TSLA", type: "Common Stock")
    ])
}
