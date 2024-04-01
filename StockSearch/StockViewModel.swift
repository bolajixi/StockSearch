//
//  StockViewModel.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation

//let baseURL: String = "https://csci-571-hw3-backend.wl.r.appspot.com"
let baseURL: String = "http://127.0.0.1:3000"

class StockViewModel: ObservableObject {
    public var holdingStockResponse: StockDataResponse?
    
    @Published var stockDataResponse: StockDataResponse?
    @Published var watchlistResponse: WatchlistResponse?
    @Published var portfolioResponse: PortfolioResponse?
    
    @Published var dataIsAvailable: Bool = false
    @Published var stockNotFound: Bool = false
//    @Published var error: Error?

    func fetchData(forTicker ticker: String, completion: @escaping (StockDataResponse?) -> Void) {
        var infoData: Info?
        var summary: Summary?
        var recommendations: [RecommendationData]?
        var latestNews: [NewsItem]?
        var peers: [String]?
        var sentiment: [SentimentData]?
        var earnings: [EarningsData]?

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

        // Notify when all tasks are completed
        group.notify(queue: .main) {
            if let infoData = infoData, let summary = summary, let recommendations = recommendations, let latestNews = latestNews, let peers = peers, let sentiment = sentiment, let earnings = earnings {
                let stockDataResponse = StockDataResponse(info: infoData, summary: summary, recommendations: recommendations, latestNews: latestNews, peers: peers, sentiment: sentiment, earnings: earnings)
                self.stockDataResponse = stockDataResponse
                self.holdingStockResponse = stockDataResponse
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
    
    private func fetchRecommendations(forTicker ticker: String, completion: @escaping ([RecommendationData]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/recommendation") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let recommendationResponse = try? JSONDecoder().decode(RecommendationAPIResponse.self, from: data) {
                completion(recommendationResponse.data)
            } else {
                print("Failed to decode recommendation data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchLatestNews(forTicker ticker: String, completion: @escaping ([NewsItem]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/news") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let latestNewsResponse = try? JSONDecoder().decode(LatestNewsAPIResponse.self, from: data) {
                completion(latestNewsResponse.data)
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
                completion(peersResponse.data)
            } else {
                print("Failed to decode peers data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchSentiment(forTicker ticker: String, completion: @escaping ([SentimentData]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/insiderSentiment") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let sentimentResponse = try? JSONDecoder().decode(SentimentAPIResponse.self, from: data) {
                completion(sentimentResponse.data.data)
            } else {
                print("Failed to decode sentiment data")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchEarning(forTicker ticker: String, completion: @escaping ([EarningsData]?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/earnings") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let earningsResponse = try? JSONDecoder().decode(EarningsAPIResponse.self, from: data) {
                completion(earningsResponse.data)
            } else {
                print("Failed to decode earnings data")
                completion(nil)
            }
        }.resume()
    }
}
