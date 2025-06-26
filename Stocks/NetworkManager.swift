//
//  NetworkManager.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL запроса"
        case .invalidResponse(let statusCode): return "Ошибка сервера (код: \(statusCode))"//: return "Ошибка сервера"
        case .noData: return "Данные не получены"
        case .decodingError: return "Ошибка обработки данных"
        }
    }
}

struct NetworkManager {
    static let shared = NetworkManager()
    private let apiToken = Bundle.main.object(forInfoDictionaryKey: "StocksAPIKey") as! String//"d0ebrkpr01qj9mg5vtdgd0ebrkpr01qj9mg5vte0"

    private init() {}
    
    private func performRequest<T: Codable>(url: URL) async throws -> T {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(statusCode: 0)
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
    

    func fetchProfile(for stock: String) async throws -> Stock.Profile {
        let link = "https://finnhub.io/api/v1/stock/profile2?symbol=\(stock)&token=\(apiToken)"
        
        guard let url = URL(string: link) else { throw NetworkError.invalidURL }
        return try await performRequest(url: url)
    }

    func fetchCurrentPrice(for stock: String) async throws -> Stock.Price {
        let link = "https://finnhub.io/api/v1/quote?symbol=\(stock)&token=\(apiToken)"
        guard let url = URL(string: link) else { throw NetworkError.invalidURL }
        return try await performRequest(url: url)
    }

    func fetchNews(for stock: String) async throws -> [Stock.News] { 
        let from = formatDate(daysAgo(1))
        let to = formatDate(Date())
        let link = "https://finnhub.io/api/v1/company-news?symbol=\(stock)&from=\(from)&to=\(to)&token=\(apiToken)"//2025-06-17   2025-06-10
        guard let url = URL(string: link) else { throw NetworkError.invalidURL }
        return try await performRequest(url: url)
    }

    func fetchMetric(for stock: String) async throws -> MetricResponse {
        let link = "https://finnhub.io/api/v1/stock/metric?symbol=\(stock)&metric=all&token=\(apiToken)"
        guard let url = URL(string: link) else { throw NetworkError.invalidURL }
        return try await performRequest(url: url)
    }
    
    func fetchHistoricalData(for stock: String) async throws -> Stock.HistoricalData {
        let now = Date()
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!

        let from = Int(oneMonthAgo.timeIntervalSince1970)
        let to = Int(now.timeIntervalSince1970)
        
        let link = "https://finnhub.io/api/v1/stock/candle?symbol=\(stock)&resolution=D&from=\(Int(from))&to=\(Int(to))&token=\(apiToken)"
        guard let url = URL(string: link) else { throw NetworkError.invalidURL }
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
