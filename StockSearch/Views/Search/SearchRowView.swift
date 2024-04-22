//
//  SearchRowView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/21/24.
//

import SwiftUI

struct SearchRowView: View {
    let ticker: String
    let companyName: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(ticker.uppercased())
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Text(companyName.uppercased())
                .foregroundColor(.gray)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    SearchRowView(ticker: "AAPL", companyName: "Apple Inc")
}
