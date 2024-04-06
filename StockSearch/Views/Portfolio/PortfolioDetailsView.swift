//
//  PortfolioDetailsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct PortfolioDetailsView: View {
    let netWorth: Double
    let cashBalance: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Net Worth")
                Text("$\(String(format: "%.2f", netWorth))")
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Cash Balance")
                Text("$\(String(format: "%.2f", cashBalance))")
                    .fontWeight(.bold)
            }
        }
        .font(.system(size: 20))
        .padding(.top, 4.5)
        .padding(.bottom, 4.5)
    }
}

#Preview {
    PortfolioDetailsView(netWorth: 25001.51, cashBalance: 14101.04)
}
