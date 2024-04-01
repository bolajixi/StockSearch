//
//  PortfolioViewModel.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/1/24.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    @Published var portfolio: Portfolio?
    
    func fetchPortfolio(completion: @escaping (Portfolio?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/portfolio") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch portfolio data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let portfolioResponse = try? JSONDecoder().decode(PortfolioAPIResponse.self, from: data) {
                self.portfolio = portfolioResponse.data[0]
                completion(portfolioResponse.data[0])
            } else {
                print("Failed to decode portfolio data")
                completion(nil)
            }
        }.resume()
    }
}
