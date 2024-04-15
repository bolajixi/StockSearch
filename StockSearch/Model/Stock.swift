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

struct NewsItem: Codable, Identifiable {
    let category, datetime, headline: String
    let id: Int
    let image: String
    let related, source, summary: String
    let url: String
}

extension NewsItem {
    static var dummyData: NewsItem {
        .init(category: "company",
              datetime: "April 10, 2024",
              headline: "Alternative browsers report uplift after EU's DMA choice screen mandate",
              id: 126946422,
              image: "https://techcrunch.com/wp-content/uploads/2019/12/GettyImages-182865389.jpg?resize=1200,1094",
              related: "AAPL",
              source: "Yahoo",
              summary: "A flagship European Union digital market regulation appears to be shaking up competition in the mobile browser market. It's been a little over a month since the Digital Markets Act (DMA) came into application and there are early signs it's having an impact by forcing phone makers to show browser choice screens to users. Earlier Wednesday, Reuters reported growth data shared by Cyprus-based web browser Aloha and others which it said suggests the new law is stirring the competitive pot and helping",
              url: "https://finnhub.io/api/news?id=388232d514b2affc6731d2ef1b9d67f9d765ba46de14680076ee9d3cd03a3f43")
    }
    
    static var dummyData2: NewsItem {
        .init(category: "company",
              datetime: "April 10, 2024",
              headline: "Apple's India production line assembles $14B in devices: BBG",
              id: 126946427,
              image: "https://s.yimg.com/ny/api/res/1.2/lAuw4nns0WXqmbyvcNz_gw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02NzU-/https://s.yimg.com/os/creatr-uploaded-images/2024-04/c1727b50-f74a-11ee-8bfd-be2f3cb22cb7",
              related: "AAPL",
              source: "Yahoo",
              summary: "One out of every seven of Apple's (AAPL) iPhones are reportedly assembled in India, according to Bloomberg, which is valued at up to $14 billion in Apple products. Yahoo Finance Tech Editor Dan Howley joins Yahoo Finance to detail Apple's international manufacturing strategy as it seeks to expand its output past just facilities in China. For more expert insight and the latest market action, click here to watch this full episode of Yahoo Finance. Editor's note: This article was written by Luke Carberry Mogan.",
              url: "https://finnhub.io/api/news?id=fb26685a496942c239a0c830ddb03664b38076e5a5040645b9522be2a9a89fa3")
    }
}

struct SentimentData: Codable {
    var symbol: String
    var year: Int
    var month: Int
    var change: Double
    var mspr: Double
}

struct SentimentDatum {
    var positiveMSPR, negativeMSPR: Double
    var positiveChange, negativeChange: Double
}

struct EarningsDatum {
    var actual: [String]
    var estimate: [String]
    var timePeriods: [String]
}

struct RecommendationDatum {
    var strongBuy: [String]
    var buy: [String]
    var hold: [String]
    var sell: [String]
    var strongSell: [String]
    var periods: [String]
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

struct AutoCompleteAPIResponse: Codable {
    let success: Bool
    var data: AutoCompleteDataContainer
}

struct AutoCompleteDataContainer: Codable {
    let count: Int
    let result: [AutoCompleteResult]
}

struct AutoCompleteResult: Codable {
    var description: String
    var displaySymbol: String
    var symbol: String
    var type: String
}

// API Responses: END ----------------------------------------------


// Combine response model
struct StockDataResponse {
    var info: Info
    var summary: Summary
    var recommendations: RecommendationDatum
    var latestNews: [NewsItem]
    var peers: [String]
    var sentiment: SentimentDatum
    var earnings: EarningsDatum
    var priceHistory: [PriceData]
    var volumeHistory: [VolumeData]
    var ohlcHistory: [OHLCData]
}
