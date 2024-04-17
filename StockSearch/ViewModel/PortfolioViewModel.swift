//
//  PortfolioViewModel.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/1/24.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    @Published var portfolio: Portfolio?
    var netWorth: Double {
        guard let portfolio = portfolio else { return 0 }
        
        var totalNetWorth = portfolio.availableBalance
        for stock in portfolio.stocks {
            totalNetWorth += stock.totalPurchaseCost
        }
        
        return totalNetWorth
    }
    
    init() {
        fetchPortfolio { portfolio in
            if portfolio != nil {
                print("Portfolio Fetched. OK!")
            } else {
                print("Failed to fetch portfolio")
            }
        }
    }
    
    func fetchPortfolio(completion: @escaping (Portfolio?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/portfolio") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch portfolio data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let portfolioResponse = try? JSONDecoder().decode(PortfolioAPIResponse.self, from: data) {
                let stockViewModel = StockViewModel()
                var portfolio = portfolioResponse.data[0]
                
                for index in 0..<portfolio.stocks.count {
                    var portfolioStock = portfolio.stocks[index]
                    let currentIndex = index // Capture the current index

                    portfolioStock.averageCostPerShare = portfolioStock.quantity > 0 ? portfolioStock.totalPurchaseCost / Double(portfolioStock.quantity) : 0

                    stockViewModel.fetchSummary(forTicker: portfolioStock.symbol) { summary in
                        if let summary = summary {
                            portfolioStock.change = (summary.current - portfolioStock.averageCostPerShare) * Double(portfolioStock.quantity)
                            portfolioStock.changePercentage = portfolioStock.change / (portfolioStock.averageCostPerShare * Double(portfolioStock.quantity))
                            portfolioStock.marketValue = summary.current * Double(portfolioStock.quantity)

                            // Update the portfolio with the modified stock at the captured index
                            portfolio.stocks[currentIndex] = portfolioStock

                            // Check if all stock updates are completed
                            let allUpdatesCompleted = portfolio.stocks.enumerated().allSatisfy { $0.offset != currentIndex || $0.element.marketValue != 0 }

                            // If all updates are completed, update the UI
                            if allUpdatesCompleted {
                                DispatchQueue.main.async {
                                    self.portfolio = portfolio
                                }
                            }
                        }
                    }
                }

                completion(portfolioResponse.data[0])
            } else {
                print("Failed to decode portfolio data")
                completion(nil)
            }
        }.resume()
    }
    
    func buyStock(stock: String, companyName: String, quantity: Int, purchasePrice: Double, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/portfolio/\(stock.lowercased())/buy") else { return }
        
        let requestBody: [String: Any] = [
            "quantity": quantity,
            "companyName": companyName,
            "purchasePrice": purchasePrice,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing request body:", error.localizedDescription)
            completion(false)
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch portfolio data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if (try? JSONDecoder().decode(stockBuyAPIResponse.self, from: data)) != nil {
                self.fetchPortfolio(completion: { portfolio in
                    if portfolio != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                print("Failed to decdode fetch from portfolio")
                completion(false)
            }
        }.resume()
    }
    
    func sellStock(stock: String, quantity: Int, sellPrice: Double, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/portfolio/\(stock.lowercased())/sell") else { return }
        
        let requestBody: [String: Any] = [
            "quantity": quantity,
            "sellPrice": sellPrice,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing request body:", error.localizedDescription)
            completion(false)
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch portfolio data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if (try? JSONDecoder().decode(stockSellAPIResponse.self, from: data)) != nil {
                self.fetchPortfolio(completion: { portfolio in
                    if portfolio != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                print("Failed to decdode fetch from portfolio")
                completion(false)
            }
        }.resume()
    }
    
    func portfolioInStock(forTicker ticker: String) -> PortfolioStock? {
        guard let portfolio = portfolio else { return nil }
        return portfolio.stocks.first { $0.symbol == ticker.lowercased() }
    }
}
