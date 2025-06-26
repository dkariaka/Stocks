//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Дмитрий К on 18.06.2025.
//

import Foundation

class PersistenceManager {
    
    static let shared = PersistenceManager()

    private let defaults = UserDefaults.standard
    private let favoritesKey = "favorites"
    
    func getSavedStocks() async throws -> [Stock] {
        guard let data = defaults.data(forKey: favoritesKey) else {
            return []
        }
        
        return try JSONDecoder().decode([Stock].self, from: data)
    }
    
    func save(_ stock: Stock) async throws {
        var savedStocks = try await getSavedStocks()
        if !savedStocks.contains(stock) {
            savedStocks.append(stock)
            try store(savedStocks)
        }
    }
    
    func remowe(_ stock: Stock) async throws {
        var savedStocks = try await getSavedStocks()
        savedStocks.removeAll {$0 == stock}
        try store(savedStocks)
    }
    
    func isSaved(_ stock: Stock) async -> Bool {
        (try? await getSavedStocks().contains(stock)) ?? false
    }
    
    func store(_ stocks: [Stock]) throws {
        let data = try JSONEncoder().encode(stocks)
        defaults.set(data, forKey: favoritesKey)
    }

}
