//
//  InsightsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI

struct InsightsView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    let companyName: String
    let positiveMSPR, negativeMSPR, positiveChange, negativeChange: Double
    
    var body: some View {
        LazyVGrid(columns: columns, content: {
            // Row 1
            headerCell(cellValue: companyName)
            headerCell(cellValue: "MSPR")
            headerCell(cellValue: "Change")
            
            // Row 2
            headerCell(cellValue: "Total")
            dataCell(cellValue: String(format: "%.2f", (positiveMSPR + negativeMSPR)) )
            dataCell(cellValue: String(format: "%.2f", (positiveChange + negativeChange)) )
            
            // Row 3
            headerCell(cellValue: "Positive")
            dataCell(cellValue: String(format: "%.2f", positiveMSPR) )
            dataCell(cellValue: String(format: "%.2f", positiveChange) )
            
            // Row 4
            headerCell(cellValue: "Negative")
            dataCell(cellValue: String(format: "%.2f", negativeMSPR) )
            dataCell(cellValue: String(format: "%.2f", negativeChange) )
        })
    }
}

struct dataCell: View {
    let cellValue: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(cellValue)
                .padding(2.5)
            Divider()
        }
    }
}

struct headerCell: View {
    let cellValue: String
    
    var body: some View {
        dataCell(cellValue: cellValue)
            .font(.headline)
    }
}

#Preview {
    InsightsView(companyName: "Apple Inc", positiveMSPR: 200, negativeMSPR: -854.26, positiveChange: 200, negativeChange: -854.26)
}
