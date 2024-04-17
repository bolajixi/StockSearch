//
//  Portfolio.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation
import SwiftUI

import Foundation

struct PortfolioStock: Codable, Identifiable {
    var id = UUID()
    
    var symbol: String
    var companyName: String
    var quantity: Int
    var totalPurchaseCost: Double
    var purchaseHistory: [PurchaseHistory]
    var _id: String
    var purchaseDate: String
    var averageCostPerShare = 0.0
    var change: Double = 0.0
    var changePercentage: Double = 0.0
    var marketValue: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case companyName
        case quantity
        case totalPurchaseCost
        case purchaseHistory
        case _id
        case purchaseDate
    }
}

struct PurchaseHistory: Codable {
    var quantity: Int
    var purchasePrice: Double
    var _id: String
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

struct stockBuyAPIResponse: Codable {
    let success: Bool
    let data: dataContainer
}

struct stockSellAPIResponse: Codable {
    let success: Bool
    let data: dataContainer
}

struct dataContainer: Codable {
    let message: String
}
