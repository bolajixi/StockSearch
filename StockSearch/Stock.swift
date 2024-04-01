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
    var data: [NewsItem]
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
    var c: Double
    var d: Double
    var dp: Double
    var h: Double
    var l: Double
    var o: Double
    var pc: Double
    var t: String
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
//    var priceHistory: TwoYearPriceHistory
//    var volumeHistory: TwoYearVolumeHistory
//    var ohlcHistory: TwoYearOHLCHistory
//    var watchlist: Watchlist
//    var portfolio: Portfolio
}
