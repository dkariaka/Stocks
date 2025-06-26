//
//  Stock.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import Foundation
import DGCharts

struct Stock: Codable, Identifiable, Equatable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        lhs.profile.ticker == rhs.profile.ticker
    }
    
    
    var id: String { profile.ticker }
    
    var currentPrice: Price
    var profile: Profile
    var historicalData: HistoricalData?
    var news: [News]
    var metric: Metric
    
    struct Profile: Codable {
        var name: String
        var ticker: String
        var exchange: String
        var currency: String
        var ipo: String
        var marketCapitalization: Double
        var shareOutstanding: Double
        var logo: String
        var finnhubIndustry: String
    }
    
    struct Price: Codable {
        var c: Double //current price
        var d: Double //change
        var dp: Double //percent change
        var h: Double //high
        var l: Double //low
        var o: Double //open
        var pc: Double //previous close
    }
    
    struct News: Codable, Hashable, Identifiable {
        var category: String
        var datetime: Int
        var headline: String
        var id: Int
        var image: String
        var related: String
        var source: String
        var summary: String
        var url: String
    }
    
    struct HistoricalData: Codable {
        var c: [Double]
        var h: [Double]
        var l: [Double]
        var o: [Double]
        var t: [Int]
        var v: [Int]
    }
    
    struct Metric: Codable {
        var peNormalizedAnnual: Double?
        var fiftyTwoWeekHigh: Double?
        var fiftyTwoWeekLow: Double?
        var tenDayAverageTradingVolume: Double?
        var volume: Double?

        enum CodingKeys: String, CodingKey {
            case peNormalizedAnnual
            case fiftyTwoWeekHigh = "52WeekHigh"
            case fiftyTwoWeekLow = "52WeekLow"
            case tenDayAverageTradingVolume = "10DayAverageTradingVolume"
            case volume
        }
    }

}

struct MetricResponse: Codable {
    let metric: Stock.Metric
}

extension Stock.HistoricalData {
    var chartEntries: [ChartDataEntry] {
        zip(t, c).map { timestamp, closePrice in
            let x = Double(timestamp)
            let y = closePrice
            return ChartDataEntry(x: x, y: y)
        }
        .sorted(by: { $0.x < $1.x }) 
    }
}
