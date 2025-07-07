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
        
        let cacheFileName = "stock-\(ticker).json"
        
        if let cachedStock = CacheManager.shared.load(Stock.self, from: cacheFileName) {
            self.stock = cachedStock
            print("Loaded stock from cache")
        }

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
            CacheManager.shared.save(stock, to: cacheFileName)
            print("Stock updated from API and cached")
        } catch {
            errorMessage = (error as? Errors)?.rawValue ?? "Unknown error"
            if self.stock == nil {
                errorMessage = "Unable to load data. Please check your internet connection."
            }
        }

        isLoading = false
    }

    @MainActor
    func fetchChart(for ticker: String, interval: ChartInterval) async {
        chartData = []
        
        let cacheFileName = "chart-\(ticker)-\(interval.rawValue).json"
        
        if CacheManager.shared.isCacheValid(for: cacheFileName, maxAgeMinutes: 1440),
           let cachedChart = CacheManager.shared.load([ChartPoint].self, from: cacheFileName) {
            chartData = cachedChart
            print("Loaded chart data from cache")
            return
        }

        do {
            let response = try await networkManager.fetchHistoricalData(for: ticker, interval: interval)
            self.chartData = response.chartPoints
            
            CacheManager.shared.save(response.chartPoints, to: cacheFileName)
            print("Saved chart data to cache")
        } catch {
            print("Failed to load chart data: \(error)")
            chartData = []
        }
    }

}
