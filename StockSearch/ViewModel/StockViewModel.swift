//
//  StockViewModel.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation
import Combine

//let baseURL: String = "https://csci-571-hw3-backend.wl.r.appspot.com"
let baseURL: String = "http://127.0.0.1:3000"

class StockViewModel: ObservableObject {
    public var holdingStockResponse: StockDataResponse?
    @Published var searchTerm: String = ""
    
    @Published var stockDataResponse: StockDataResponse?
    @Published var isLoading = false
    @Published var stockNotFound: Bool = false
    
    @Published var autocompleteData: [AutoCompleteResult]?
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        
        $searchTerm
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.clear()
                self?.fetchAutoComplete(forSearchTerm: term) { success in
                    if success {
                        print("Auto fetch is good")
                    } else {
                        print("Auto fetch failed")
                    }
                }
            }.store(in: &subscriptions)
    }
    
    func clear() {
        stockDataResponse = nil
        autocompleteData = []
    }
    
    func fetchAutoComplete(forSearchTerm term: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search?q=\(term.lowercased())") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch autocomplete data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let autocompleteResponse = try? JSONDecoder().decode(AutoCompleteAPIResponse.self, from: data) {
                self.autocompleteData = autocompleteResponse.data.result
                completion(true)
            } else {
                print("Failed to decode autocomplete data")
                completion(false)
            }
        }.resume()
    }

    func fetchData(forTicker ticker: String, completion: @escaping (StockDataResponse?) -> Void) {
        isLoading = stockDataResponse == nil
        stockDataResponse = nil
        
        var infoData: Info?
        var summary: Summary?
        var recommendations: RecommendationDatum?
        var latestNews: [NewsItem]?
        var peers: [String]?
        var sentiment: SentimentDatum?
        var earnings: EarningsDatum?
        var priceHistory: [PriceData]?
        var volumeHistory: [VolumeData]?
        var ohlcHistory: [OHLCData]?

        let group = DispatchGroup()

        group.enter()
        fetchInfo(forTicker: ticker) { info in
            infoData = info
            group.leave()
        }
        
        group.enter()
        fetchSummary(forTicker: ticker) { data in
            summary = data
            group.leave()
        }

        group.enter()
        fetchRecommendations(forTicker: ticker) { data in
            recommendations = data
            group.leave()
        }
        
        group.enter()
        fetchLatestNews(forTicker: ticker) { data in
            latestNews = data
            group.leave()
        }
        
        group.enter()
        fetchPeers(forTicker: ticker) { data in
            peers = data
            group.leave()
        }
        
        group.enter()
        fetchSentiment(forTicker: ticker) { data in
            sentiment = data
            group.leave()
        }
        
        group.enter()
        fetchEarning(forTicker: ticker) { data in
            earnings = data
            group.leave()
        }
        
        group.enter()
        fetchHistory(forTicker: ticker) { priceData, volumeData, ohlcData in
            if let priceData = priceData, let volumeData = volumeData, let ohlcData = ohlcData {
                priceHistory = priceData
                volumeHistory = volumeData
                ohlcHistory = ohlcData
            } else {
                print("Failed to fetch history data")
            }

            group.leave()
        }
        
        // Notify when all tasks are completed
        group.notify(queue: .main) {
            if let infoData = infoData, let summary = summary, let recommendations = recommendations, let latestNews = latestNews, let peers = peers, let sentiment = sentiment, let earnings = earnings, let priceHistory = priceHistory, let volumeHistory = volumeHistory, let ohlcHistory = ohlcHistory {
                let stockDataResponse = StockDataResponse(info: infoData, summary: summary, recommendations: recommendations, latestNews: latestNews, peers: peers, sentiment: sentiment, earnings: earnings, priceHistory: priceHistory, volumeHistory: volumeHistory, ohlcHistory: ohlcHistory)
                self.stockDataResponse = stockDataResponse
                self.holdingStockResponse = stockDataResponse
                
                self.isLoading = false
                
                completion(stockDataResponse)
            } else {
                completion(nil)
            }
        }
    }
    
    private func fetchInfo(forTicker ticker: String, completion: @escaping (Info?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let infoResponse = try? JSONDecoder().decode(InfoAPIResponse.self, from: data) {
                completion(infoResponse.data)
            } else {
                print("Failed to decode info data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchSummary(forTicker ticker: String, completion: @escaping (Summary?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/summary") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let summaryResponse = try? JSONDecoder().decode(SummaryAPIResponse.self, from: data) {
                completion(summaryResponse.data)
            } else {
                print("Failed to decode summary data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchRecommendations(forTicker ticker: String, completion: @escaping (RecommendationDatum?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/recommendation") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let recommendationResponse = try? JSONDecoder().decode(RecommendationAPIResponse.self, from: data) {
                let parsedData = self.parseRecommendation(recommendations: recommendationResponse)
                completion(parsedData)
            } else {
                print("Failed to decode recommendation data")
                completion(nil)
            }
        }.resume()
    }
    
    private func parseRecommendation(recommendations: RecommendationAPIResponse) -> RecommendationDatum {
        var strongBuy = [String]()
        var buy = [String]()
        var hold = [String]()
        var sell = [String]()
        var strongSell = [String]()
        var periods = [String]()
        
        for recommendation in recommendations.data {
            periods.append(String(recommendation.period.prefix(7)))
            strongSell.append(String(recommendation.strongSell))
            strongBuy.append(String(recommendation.strongBuy))
            sell.append(String(recommendation.sell))
            buy.append(String(recommendation.buy))
            hold.append(String(recommendation.hold))
        }
        
        return RecommendationDatum(strongBuy: strongBuy, buy: buy, hold: hold, sell: sell, strongSell: strongSell, periods: periods)
    }
    
    private func fetchLatestNews(forTicker ticker: String, completion: @escaping ([NewsItem]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/news") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let latestNewsResponse = try? JSONDecoder().decode(LatestNewsAPIResponse.self, from: data) {
                let first20News = Array(latestNewsResponse.data.prefix(20))
                completion(first20News)
            } else {
                print("Failed to decode latest news data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchPeers(forTicker ticker: String, completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/peers") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let peersResponse = try? JSONDecoder().decode(PeersAPIResponse.self, from: data) {
                let filteredPeers = peersResponse.data.filter { !$0.contains(".") }
                let uniqueFilteredPeers = Array(Set(filteredPeers))
                
                completion(uniqueFilteredPeers)
            } else {
                print("Failed to decode peers data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchSentiment(forTicker ticker: String, completion: @escaping (SentimentDatum?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/insiderSentiment") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let sentimentResponse = try? JSONDecoder().decode(SentimentAPIResponse.self, from: data) {
                let sentiments = sentimentResponse.data.data
                
                var positiveMsrp = 0.0
                var negativeMsrp = 0.0
                var positiveChange = 0.0
                var negativeChange = 0.0
                
                for item in sentiments {
                    if item.mspr > 0 {
                        positiveMsrp += item.mspr
                    } else {
                        negativeMsrp += item.mspr
                    }
                    
                    if item.change > 0 {
                        positiveChange += item.change
                    } else {
                        negativeChange += item.change
                    }
                }
                
                let sentimentDatum = SentimentDatum(positiveMSPR: positiveMsrp, negativeMSPR: negativeMsrp, positiveChange: positiveChange, negativeChange: negativeChange)
                
                completion(sentimentDatum)
            } else {
                print("Failed to decode sentiment data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchEarning(forTicker ticker: String, completion: @escaping (EarningsDatum?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/earnings") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let earningsResponse = try? JSONDecoder().decode(EarningsAPIResponse.self, from: data) {
                DispatchQueue.main.async {
                    let earningsDatum = self.parseEarnings(earnings: earningsResponse)
                    completion(earningsDatum)
                }
            } else {
                print("Failed to decode earnings data")
                completion(nil)
            }
        }.resume()
    }
    
    private func parseEarnings(earnings: EarningsAPIResponse) -> EarningsDatum {
        let actual = earnings.data.map { "\($0.period): \($0.actual)" }
        let estimate = earnings.data.map { "\($0.period): \($0.estimate)" }
        let timePeriods = earnings.data.map { "\($0.period)<br>Surprise: \($0.surprise)" }
        
        return EarningsDatum(actual: actual, estimate: estimate, timePeriods: timePeriods)
    }
    
    private func fetchHistory(forTicker ticker: String, completion: @escaping ([PriceData]?, [VolumeData]?, [OHLCData]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/history") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let historyResponse = try? JSONDecoder().decode(HistoryAPIResponse.self, from: data) {
                let priceHistoryData = historyResponse.data.results.map {  PriceData(timestamp: $0.timestamp, price: $0.close) }
                let volumeHistoryData = historyResponse.data.results.map { VolumeData(timestamp: $0.timestamp, volume: $0.volume) }
                let ohlcData = historyResponse.data.results.map { OHLCData(timestamp: $0.timestamp, open: $0.open, close: $0.close, high: $0.high, low: $0.low) }

                completion(priceHistoryData, volumeHistoryData, ohlcData)
            } else {
                print("Failed to decode history data")
                completion(nil, nil, nil)
            }
        }.resume()
    }
}
