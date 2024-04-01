//
//  Stock.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation
import SwiftUI

// App Reponse Format Type --------------------------------------------
struct RecommendationData: Codable {
    var buy: Int
    var hold: Int
    var period: String
    var sell: Int
    var strongBuy: Int
    var strongSell: Int
    var symbol: String
}

struct PriceData: Codable, Identifiable {
    var id = UUID()
    var timestamp: Int
    var price: Double
}

struct VolumeData: Codable, Identifiable {
    var id = UUID()
    var timestamp: Int
    var volume: Double
}

struct OHLCData: Codable, Identifiable {
    var id = UUID()
    var timestamp: Int
    var open: Double
    var close: Double
    var high: Double
    var low: Double
}

struct NewsItem: Codable {
    var category: String
    var datetime: String
    var headline: String
    var image: String
    var related: String
    var source: String
    var summary: String
    var url: String
}

struct SentimentData: Codable {
    var symbol: String
    var year: Int
    var month: Int
    var change: Int
    var mspr: Double
}

struct HistoryData: Codable {
    var volume: Double
    var volumeWeightedAveragePrice: Double
    var open: Double
    var close: Double
    var high: Double
    var low: Double
    var timestamp: Int
    var numberOfTrades: Int
    
    enum CodingKeys: String, CodingKey {
        case volume = "v"
        case volumeWeightedAveragePrice = "vw"
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case timestamp = "t"
        case numberOfTrades = "n"
    }
}

struct EarningsData: Codable {
    var actual: Double
    var estimate: Double
    var period: String
    var quarter: Int
    var surprise: Double
    var surprisePercent: Double
    var symbol: String
    var year: Int
}

struct Info: Codable {
    var country: String
    var currency: String
    var estimateCurrency: String
    var exchange: String
    var finnhubIndustry: String
    var ipo: String
    var logo: String
    var marketCapitalization: Double
    var name: String
    var phone: String
    var shareOutstanding: Double
    var ticker: String
    var weburl: String
}

struct Summary: Codable {
    var current: Double
    var change: Double
    var changePercentage: Double
    var high: Double
    var low: Double
    var open: Double
    var previousClose: Double
    var timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case current = "c"
        case change = "d"
        case changePercentage = "dp"
        case high = "h"
        case low = "l"
        case open = "o"
        case previousClose = "pc"
        case timestamp = "t"
    }
}

struct TwoYearPriceHistory: Identifiable  {
    var id = UUID()
    var data: [PriceData]
}

struct TwoYearVolumeHistory: Identifiable  {
    var id = UUID()
    var data: [VolumeData]
}

struct TwoYearOHLCHistory: Identifiable  {
    var id = UUID()
    var data: [OHLCData]
}

// API Responses: START --------------------------------------------

struct InfoAPIResponse: Codable {
    let success: Bool
    let data: Info
}

struct SummaryAPIResponse: Codable {
    let success: Bool
    let data: Summary
}

struct RecommendationAPIResponse: Codable {
    let success: Bool
    let data: [RecommendationData]
}

struct LatestNewsAPIResponse: Codable  {
    let success: Bool
    var data: [NewsItem]
}

struct HistoryAPIResponse: Codable  {
    let success: Bool
    var data: HistoryDataContainer
}

struct HistoryDataContainer: Codable {
    let ticker: String
    let queryCount: Int
    let resultsCount: Int
    let adjusted: Bool
    let results: [HistoryData]
    let status: String
    let request_id: String
    let count: Int
}

struct PeersAPIResponse: Codable {
    let success: Bool
    var data: [String]
}

struct SentimentAPIResponse: Codable {
    let success: Bool
    let data: SentimentDataContainer
}

struct SentimentDataContainer: Codable {
    let data: [SentimentData]
    let symbol: String
}

struct EarningsAPIResponse: Codable {
    let success: Bool
    var data: [EarningsData]
}

// API Responses: END ----------------------------------------------

//struct Watchlist: Identifiable  {
//    var id = UUID()
//}
//
//struct Portfolio: Identifiable  {
//    var id = UUID()
//}

// Combine response model
struct StockDataResponse {
    var info: Info
    var summary: Summary
    var recommendations: [RecommendationData]
    var latestNews: [NewsItem]
    var peers: [String]
    var sentiment: [SentimentData]
    var earnings: [EarningsData]
    var priceHistory: [PriceData]
    var volumeHistory: [VolumeData]
    var ohlcHistory: [OHLCData]
//    var watchlist: Watchlist
//    var portfolio: Portfolio
}
