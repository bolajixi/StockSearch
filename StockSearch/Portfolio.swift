//
//  Portfolio.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation

struct PortfolioStock: Codable, Identifiable {
    var id: String
    var symbol: String
    var companyName: String
    var quantity: Int
    var totalPurchaseCost: Double
    var purchaseHistory: [PurchaseHistory]
    var purchaseDate: String
}

struct PurchaseHistory: Codable {
    var quantity: Int
    var purchasePrice: Double
    var id: String
}

struct PortfolioResponse: Codable {
    var availableBalance: Double
    var stocks: [PortfolioStock]
}
