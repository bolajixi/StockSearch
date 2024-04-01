//
//  WatchlistViewModel.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/1/24.
//

import Foundation

class WatchlistViewModel: ObservableObject {
    @Published var watchlist: Watchlist?
    
    func fetchWatchlist(completion: @escaping (Watchlist?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/watchlist") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch portfolio data:", error?.localizedDescription ?? "Unknown error")
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
    
}
