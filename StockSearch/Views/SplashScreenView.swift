//
//  SplashScreenView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct SplashScreenView: View {    
    @State private var isActive = false
    let splashScreenDuration = 4.5
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            VStack {
                Image("AppIcon_512")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 290, height: 290) 
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDuration) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(StockViewModel())
        .environmentObject(WatchlistViewModel())
        .environmentObject(PortfolioViewModel())
}
