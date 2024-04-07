//
//  StockSearchApp.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import SwiftUI

@main
struct StockSearchApp: App {
    let stockViewModel = StockViewModel()
    let watchlistViewModel = WatchlistViewModel()
    let portfolioViewModel = PortfolioViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(stockViewModel)
                .environmentObject(watchlistViewModel)
                .environmentObject(portfolioViewModel)
        }
    }
}
