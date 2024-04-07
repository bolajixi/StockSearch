//
//  WatchlistViewModel.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/1/24.
//

import Foundation

class WatchlistViewModel: ObservableObject {
    @Published var watchlist: Watchlist?
    
    init() {
        fetchWatchlist { watchlist in
            if watchlist != nil {
                print("Watchlist Fetched:", self.watchlist!)
            } else {
                print("Failed to fetch watchlist")
            }
        }
    }
    
    func fetchWatchlist(completion: @escaping (Watchlist?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/watchlist") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch watchlist data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let watchlistResponse = try? JSONDecoder().decode(WatchlistAPIResponse.self, from: data) {
                self.watchlist = watchlistResponse.data
                completion(watchlistResponse.data)
            } else {
                print("Failed to decode watchlist data")
                completion(nil)
            }
        }.resume()
    }
    
    func addToWatchlist(stock: String, companyName: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/watchlist") else { return }
        
        let requestBody: [String: Any] = [
            "ticker": stock,
            "companyName": companyName
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
            
            if let watchlistResponse = try? JSONDecoder().decode(WatchlistAPIResponse.self, from: data) {
                self.watchlist = watchlistResponse.data
                completion(true)
            } else {
                print("Failed to remove from watchlist")
                completion(false)
            }
        }.resume()
    }
    
    func removeFromWatchlist(stock: String, companyName: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/watchlist") else { return }
        
        let requestBody: [String: Any] = [
            "ticker": stock,
            "companyName": companyName
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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
            
            if let watchlistResponse = try? JSONDecoder().decode(WatchlistAPIResponse.self, from: data) {
                self.watchlist = watchlistResponse.data
                completion(true)
            } else {
                print("Failed to remove from watchlist")
                completion(false)
            }
        }.resume()
    }
    
}
