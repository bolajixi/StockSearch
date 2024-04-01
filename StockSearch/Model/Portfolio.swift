//
//  Portfolio.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation
import SwiftUI

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

struct Portfolio: Codable {
    var _id: String
    var availableBalance: Double
    var stocks: [PortfolioStock]
    var __v: Int
}

// API Responses: START --------------------------------------------
struct PortfolioAPIResponse: Codable {
    let success: Bool
    let data: [Portfolio]
}
