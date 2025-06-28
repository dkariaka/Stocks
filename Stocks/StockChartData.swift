//
//  StockChartData.swift
//  Stocks
//
//  Created by Дмитрий К on 27.06.2025.
//

import Foundation

struct StockChartData: Codable {
    let meta: Meta?
    let values: [Value]?
    let status: String?
    
    struct Meta: Codable {
        let symbol: String?
        let interval: String?
        let currency: String?
    }
    
    struct Value: Codable {
        let datetime: String?
        let open: String?
        let high: String?
        let low: String?
        let close: String?
        let volume: String?
    }
}

struct ChartPoint: Identifiable {
    let id = UUID()
    let date: Date
    let close: Double
}

extension StockChartData {
    var chartPoints: [ChartPoint] {
        (values ?? []).compactMap { value -> ChartPoint? in
            guard
                let dateString = value.datetime,
                let date = DateFormatter.chart.date(from: dateString),
                let closeString = value.close,
                let close = Double(closeString)
            else {
                return nil
            }
            return ChartPoint(date: date, close: close)
        }
    }
}



extension DateFormatter {
    static let chart: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}



