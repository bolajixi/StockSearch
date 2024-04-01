//
//  StockViewModel.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 3/31/24.
//

import Foundation

class StockViewModel: ObservableObject {
    @Published var stockDataResponse: StockDataResponse?
    
    @Published var dataIsAvailable: Bool = false
    @Published var stockNotFound: Bool = false
//    @Published var error: Error?

    func fetchData(ticker: String) {
        // Your networking code goes here
        // Replace baseURL and other placeholder values with your actual API URL and parameters

        // For demonstration purposes, I'll use mock data
//        let mockData = ''
//        self.stockDataResponse = mockData.generateMockResponse()
//        self.dataIsAvailable = true
    }
}
