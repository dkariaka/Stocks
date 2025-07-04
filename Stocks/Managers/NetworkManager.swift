//
//  NetworkManager.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    private let stockApiToken = Bundle.main.object(forInfoDictionaryKey: "StocksAPIKey") as! String
    private let chartApiToken = Bundle.main.object(forInfoDictionaryKey: "ChartAPIKey") as! String

    private init() {}
    
    private func performRequest<T: Codable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Errors.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw Errors.invalidResponse
        }
    
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw Errors.decodingError
        }
    }
    

    func fetchProfile(for stock: String) async throws -> Stock.Profile {
        let link = "https://finnhub.io/api/v1/stock/profile2?symbol=\(stock)&token=\(stockApiToken)"
        
        guard let url = URL(string: link) else { throw Errors.invalidURL }
        return try await performRequest(url: url)
    }

    func fetchCurrentPrice(for stock: String) async throws -> Stock.Price {
        let link = "https://finnhub.io/api/v1/quote?symbol=\(stock)&token=\(stockApiToken)"
        guard let url = URL(string: link) else { throw Errors.invalidURL }
        return try await performRequest(url: url)
    }

    func fetchNews(for stock: String) async throws -> [Stock.News] { 
        let from = formatDate(daysAgo(1))
        let to = formatDate(Date())
        let link = "https://finnhub.io/api/v1/company-news?symbol=\(stock)&from=\(from)&to=\(to)&token=\(stockApiToken)"
        guard let url = URL(string: link) else { throw Errors.invalidURL }
        return try await performRequest(url: url)
    }

    func fetchMetric(for stock: String) async throws -> MetricResponse {
        let link = "https://finnhub.io/api/v1/stock/metric?symbol=\(stock)&metric=all&token=\(stockApiToken)"
        guard let url = URL(string: link) else { throw Errors.invalidURL }
        return try await performRequest(url: url)
    }
    
    func fetchHistoricalData(for stock: String, interval: ChartInterval) async throws -> StockChartData {
        let link = "https://api.twelvedata.com/time_series?symbol=\(stock)&interval=\(interval.appInterval)&outputsize=\(interval.outputSize)&apikey=\(chartApiToken)"
        guard let url = URL(string: link) else { throw Errors.invalidURL }
        return try await performRequest(url: url)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: date)
    }
    
    func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
}


