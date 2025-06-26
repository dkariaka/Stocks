//
//  StockDetailViewModel.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import Foundation

class StockDetailViewModel: ObservableObject {
    @Published var stock: Stock?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let persistence = PersistenceManager.shared

    private let networkManager = NetworkManager.shared
    

    @MainActor
    func addToFavorites() async {
        guard let stock = stock else { return }
        do {
            try await persistence.save(stock)
            print("Added \(stock.profile.ticker)")
        } catch {
            errorMessage = "Error adding to favorites"
        }
    }


    @MainActor
    func fetchStock(for ticker: String) async {
        isLoading = true
        errorMessage = nil

        do {
            async let profile = networkManager.fetchProfile(for: ticker)
            async let price = networkManager.fetchCurrentPrice(for: ticker)
            async let news = networkManager.fetchNews(for: ticker)
            async let metricResponse = networkManager.fetchMetric(for: ticker)
            //async let historicalData = networkManager.fetchHistoricalData(for: ticker)

            let stock = Stock(
                currentPrice: try await price,
                profile: try await profile,
                historicalData: nil,        //try await historicalData,
                news: try await news,
                metric: try await metricResponse.metric
            )

            self.stock = stock
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? "Unknown error"
        }

        isLoading = false
    }
    

}
