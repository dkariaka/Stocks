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
        let stocksToRemove = offsets.map { favoriteStocks[$0] }
        
        favoriteStocks.remove(atOffsets: offsets)
        
        for stock in stocksToRemove {
            do {
                try await PersistenceManager.shared.remowe(stock)
            } catch {
                print("Error while deleting: \(error)")
            }
        }
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
}
