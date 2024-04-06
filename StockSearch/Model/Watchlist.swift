//
//  Watchlist.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation
import SwiftUI

struct WatchlistStock: Codable {
    var ticker: String
    var companyName: String
    var currentPrice: Double
    var priceChange: Double
    var priceChangePercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case ticker = "ticker"
        case companyName = "companyName"
        case currentPrice = "c"
        case priceChange = "d"
        case priceChangePercentage = "dp"
    }
}

struct Watchlist: Codable {
    var stocks: [WatchlistStock]
}

// API Responses: START --------------------------------------------
struct WatchlistAPIResponse: Codable {
    let success: Bool
    let data: Watchlist
}
