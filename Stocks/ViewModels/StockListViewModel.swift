//
//  StockListViewModel.swift
//  Stocks
//
//  Created by Дмитрий К on 15.05.2025.
//

import Foundation
import Combine

class StockListViewModel: ObservableObject {
    @Published var favoriteStocks: [Stock] = []
    @Published var searchText: String = ""
    @Published var selectedStock: Stock?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager.shared

    
    @MainActor
    func deleteStocks(at offsets: IndexSet) async {
        for index in offsets {
            let stockToRemove = favoriteStocks[index]
            do {
                try await PersistenceManager.shared.remowe(stockToRemove)
            } catch {
                print("Error while deleting: \(error)")
            }
        }
        
        await fetchFavoriteStocks()
    }

    
    
    @MainActor
    func fetchFavoriteStocks() async {
        isLoading = true
        errorMessage = nil
        favoriteStocks.removeAll()

        do {
            let saved = try await PersistenceManager.shared.getSavedStocks()
            favoriteStocks = saved
        } catch {
            errorMessage = "Error loading favorites"
        }

        isLoading = false
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

            selectedStock = stock
            
        } catch {
            errorMessage = (error as? Errors)?.rawValue ?? "Unknown error"
        }
        isLoading = false
    }

    private func fetchStockData(for ticker: String) async throws -> Stock {
        async let profile = networkManager.fetchProfile(for: ticker)
        async let price = networkManager.fetchCurrentPrice(for: ticker)
        async let news = networkManager.fetchNews(for: ticker)
        async let metric = networkManager.fetchMetric(for: ticker)
        
        return try await Stock(
            currentPrice: price,
            profile: profile,
            news: news,
            metric: metric.metric
        )
    }
}
