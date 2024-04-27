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
    private var timer: Timer?
    private var privateSearchTerm: String = ""
    
    @Published var searchTerm: String = ""
    @Published var stockDataResponse: StockDataResponse?
    @Published var isLoading = false
    @Published var stockColor: String = ""
    @Published var marketIsOpen = false
    @Published var autocompleteData: [AutoCompleteResult]?
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchTerm
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .seconds(0.6), scheduler: RunLoop.main)
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
//        stockDataResponse = nil
        autocompleteData = []
    }
    
    func fetchAutoComplete(forSearchTerm term: String, completion: @escaping (Bool) -> Void) {
        print(term)
        guard term.count > 0 else {
            print("Search term should be more than one character")
            completion(false)
            return
        }
        
        guard let url = URL(string: "\(baseURL)/api/v1/search?q=\(term.lowercased())") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch autocomplete data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let autocompleteResponse = try? JSONDecoder().decode(AutoCompleteAPIResponse.self, from: data) {
                let filteredResults = autocompleteResponse.data.result.filter { result in
                    return result.type == "Common Stock" && !result.displaySymbol.contains(".")
                }
                DispatchQueue.main.async {
                    self.autocompleteData = filteredResults
                }
                completion(true)
            } else {
                print("Failed to decode autocomplete data")
                completion(false)
            }
        }.resume()
    }

    func fetchData(forTicker ticker: String, completion: @escaping (StockDataResponse?) -> Void) {
        if ticker.count > 0 {
            privateSearchTerm = ticker
        }
        isLoading = stockDataResponse == nil
        stockDataResponse = nil
        
        var infoData: Info?
        var summary: Summary?
        var recommendations: RecommendationDatum?
        var latestNews: [NewsItem]?
        var peers: [String]?
        var sentiment: SentimentDatum?
        var earnings: EarningsDatum?
        var history: HistoryDatum?

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
        fetchHistory(forTicker: ticker) { data in
            history = data
            group.leave()
        }
        
        // Notify when all tasks are completed
        group.notify(queue: .main) {
            if let infoData = infoData, 
                let summary = summary,
                let recommendations = recommendations,
                let latestNews = latestNews,
                let peers = peers,
                let sentiment = sentiment,
                let earnings = earnings,
                let history = history {
                
                self.fetchHourlyHistory(forTicker: ticker, closingDate: summary.timestamp) { hourlyData in
                    guard let hourlyData = hourlyData else {
                            print("Error: Hourly data is nil")
                            return
                        }
                    let stockDataResponse = StockDataResponse(
                        info: infoData,
                        summary: summary,
                        recommendations: recommendations,
                        latestNews: latestNews,
                        peers: peers,
                        sentiment: sentiment,
                        earnings: earnings,
                        history: history,
                        hourlyHistory: hourlyData
                    )
                    
                    self.stockDataResponse = stockDataResponse
                    self.holdingStockResponse = stockDataResponse
                    self.stockColor = self.getStockColor(value: stockDataResponse.summary.changePercentage)
                    
                    self.isLoading = false
                    completion(stockDataResponse)
                }
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
    
    public func fetchSummary(forTicker ticker: String, completion: @escaping (Summary?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/summary") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let summaryResponse = try? JSONDecoder().decode(SummaryAPIResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.marketIsOpen = self.isMarketOpen(timestamp: summaryResponse.data.timestamp)
                }
                completion(summaryResponse.data)
            } else {
                print("Failed to decode summary data")
                completion(nil)
            }
        }.resume()
    }
    
    private func isMarketOpen(timestamp: String) -> Bool {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let lastTimestamp = dateFormatter.date(from: timestamp) else {
            
            return false
        }
        
        let elapsedTime = currentTime.timeIntervalSince(lastTimestamp)
        let elapsedInMinutes = elapsedTime / 60
        
        if elapsedInMinutes <= 5 {
            return true
        } else {
            return false
        }
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
        let actual = earnings.data.map { ["\($0.period)", $0.actual] }
        let estimate = earnings.data.map { ["\($0.period)", $0.estimate] }
        let timePeriods = earnings.data.map { "\($0.period)<br>Surprise: \($0.surprise)" }
        
        return EarningsDatum(actual: actual, estimate: estimate, timePeriods: timePeriods)
    }
    
    private func fetchHistory(forTicker ticker: String, completion: @escaping (HistoryDatum?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/history") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let historyResponse = try? JSONDecoder().decode(HistoryAPIResponse.self, from: data) {
                DispatchQueue.main.async {
                    let historyDatum = self.parseHistory(history: historyResponse)
                    completion(historyDatum)
                }
            } else {
                print("Failed to decode history data")
                completion(nil)
            }
        }.resume()
    }
    
    private func parseHistory(history: HistoryAPIResponse) -> HistoryDatum {
        let priceHistoryData = history.data.results.map { [$0.timestamp, $0.close] }
        let volumeHistoryData = history.data.results.map { [$0.timestamp, $0.volume] }
        let ohlcData = history.data.results.map { [$0.timestamp, $0.open, $0.close, $0.high, $0.low] }
        
        return HistoryDatum(price: priceHistoryData, volume: volumeHistoryData, ohlc: ohlcData)
    }
    
    private func fetchHourlyHistory(forTicker ticker: String, closingDate: String, completion: @escaping (HistoryDatum?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let _closingDate = dateFormatter.date(from: closingDate) else {
            print("Failed to parse closing date")
            return
        }
        
        guard let (startTimestamp, endTimestamp) = calculateTimes(closingDate: _closingDate) else {
            print("Failed to calculate times")
            return
        }
        
        
        let fromDateFormatted = formatDate(startTimestamp)
        let toDateFormatted = formatDate(endTimestamp)
        
        guard let url = URL(string: "\(baseURL)/api/v1/search/\(ticker)/history?from=\(fromDateFormatted)&to=\(toDateFormatted)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch info data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let hourlyHistoryResponse = try? JSONDecoder().decode(HistoryAPIResponse.self, from: data) {
                DispatchQueue.main.async {
                    let hourlyHistoryDatum = self.parseHistory(history: hourlyHistoryResponse)
                    completion(hourlyHistoryDatum)
                }
            } else {
                print("Failed to decode history data")
                completion(nil)
            }
        }.resume()
    }
    
    private func calculateTimes(closingDate: Date) -> (Date, Date)? {
        let today = Date()
        
        var startTime = Date()
        var endTime = today
        endTime = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        
        if marketIsOpen {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
            startTime = Calendar.current.startOfDay(for: yesterday)
        } else {
            let marketClose = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: closingDate) ?? Date()
            let oneDayBeforeClose = Calendar.current.date(byAdding: .day, value: -1, to: marketClose) ?? Date()
            startTime = Calendar.current.startOfDay(for: oneDayBeforeClose)
            endTime = marketClose
        }
        
        return (startTime, endTime)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
    func getStockColor(value: Double) -> String {
        if value > 0 {
            return "green"
        } else if value < 0 {
            return "red"
        } else {
            return "black"
        }
    }
    
    private func startSummaryTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if privateSearchTerm.count > 0 {
                self.fetchSummary(forTicker: privateSearchTerm) { summary in
                    if let summary = summary {
                        DispatchQueue.main.async {
                            self.stockDataResponse?.summary = summary
                            print("Stock price updated for \(self.privateSearchTerm)...")
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        stopSummaryTimer()
    }
    
    private func stopSummaryTimer() {
        print("Stopping update for \(self.privateSearchTerm)...")
        timer?.invalidate()
        timer = nil
    }
}
