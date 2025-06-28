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
    @Published var chartData: [ChartPoint] = []
    
    private let persistence = PersistenceManager.shared

    private let networkManager = NetworkManager.shared
    

    @MainActor
    func addToFavorites() async {
        guard let stock = stock else { return }
        do {
            try await persistence.save(stock)
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

            let stock = Stock(
                currentPrice: try await price,
                profile: try await profile,
                news: try await news,
                metric: try await metricResponse.metric
            )

            self.stock = stock
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription ?? "Unknown error"
        }

        isLoading = false
    }
    
    @MainActor
    func fetchChart(for ticker: String) async {
        do {
            let response = try await networkManager.fetchHistoricalData(for: ticker)
            self.chartData = response.chartPoints
        } catch {
            print("Failed to load chart data: \(error)")
        }
    }

}
