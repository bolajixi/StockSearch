//
//  Watchlist.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation
import SwiftUI

struct WatchlistStock: Codable, Identifiable {
    var id = UUID()
    var ticker: String
    var companyName: String
    var currentPrice: Double
    var priceChange: Double
    var priceChangePercentage: Double
}

struct WatchlistResponse: Codable {
    var stocks: [WatchlistStock]
}
