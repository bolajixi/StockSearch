//
//  AlertPopupView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/10/24.
//

import SwiftUI

struct AlertPopupView: View {
    var alertText: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(alertText)
                .frame(width: 260)
                .padding(25)
                .background(Color.gray)
                .foregroundColor(Color.white)
            .cornerRadius(50)
        }
        .transition(.opacity)
        .animation(.default)
    }
}

#Preview {
    AlertPopupView(alertText: "Please enter a valid amount")
}
