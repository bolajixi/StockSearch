//
//  Stock.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation
import SwiftUI

// App Reponse Format Type --------------------------------------------
struct RecommendationData: Codable, Identifiable {
    var id = UUID()
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
    var price: Double
    var timestamp: Int
}

struct VolumeData: Codable, Identifiable {
    var id = UUID()
    var volume: Double
    var timestamp: Int
}

struct OHLCData: Codable, Identifiable {
    var id = UUID()
    var open: Double
    var close: Double
    var high: Double
    var low: Double
    var timestamp: Int
}

struct NewsItem: Codable, Identifiable {
    var id: Int
    var category: String
    var datetime: String
    var headline: String
    var image: String
    var related: String
    var source: String
    var summary: String
    var url: String
}

struct SentimentData: Codable, Identifiable {
    var id = UUID()
    var symbol: String
    var year: Int
    var month: Int
    var change: Int
    var mspr: Double
}

struct EarningsData: Codable, Identifiable {
    var id = UUID()
    var actual: Double
    var estimate: Double
    var period: String
    var quarter: Int
    var surprise: Double
    var surprisePercent: Double
    var symbol: String
    var year: Int
}
// ----------------------------------------------------------------------

struct Info: Identifiable {
    var id = UUID()
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
    var webURL: String
}

struct Summary: Identifiable {
    var id = UUID()
    var currentPrice: Double
    var priceChange: Double
    var priceChangePercentage: Double
    var high: Double
    var low: Double
    var open: Double
    var previousClose: Double
    var timestamp: String
}

struct Recommendation: Codable {
    var data: [RecommendationData]
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

struct LatestNews: Identifiable  {
    var id = UUID()
    var data: [NewsItem]
}

struct Peers: Identifiable {
    var id = UUID()
    var data: [String]
}

struct Sentiment: Identifiable  {
    var id = UUID()
    var data: [SentimentData]
}

struct Earnings: Codable {
    var id = UUID()
    var data: [EarningsData]
}

struct Watchlist: Identifiable  {
    var id = UUID()
}

struct Portfolio: Identifiable  {
    var id = UUID()
}

// Combine response model
struct StockDataResponse {
    let info: Info
    let summary: Summary
    let recommendations: Recommendation
    let priceHistory: TwoYearPriceHistory
    let volumeHistory: TwoYearVolumeHistory
    let ohlcHistory: TwoYearOHLCHistory
    let latestNews: LatestNews
    let peers: Peers
    let sentiment: Sentiment
    let earnings: Earnings
//    let watchlist: Watchlist
//    let portfolio: Portfolio
}
