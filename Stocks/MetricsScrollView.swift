//
//  MetricsScrollView.swift
//  Stocks
//
//  Created by Дмитрий К on 26.06.2025.
//

import SwiftUI

struct MetricsScrollView: View {
    //@ObservedObject var viewModel: StockDetailViewModel
    
    let stock: Stock
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Open \(stock.currentPrice.o)")
                    Text("High \(stock.currentPrice.h)")
                    Text("Low \(stock.currentPrice.l)")
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                Divider()
                    .frame(height: 60)
                
                VStack(alignment: .leading) {
                    Text("Vol \(stock.metric.volume.map {String($0)} ?? "-")")
                    Text("P/E \(stock.metric.peNormalizedAnnual.map {String($0)} ?? "-")")
                    Text("Mkt Cap \(stock.profile.marketCapitalization)")
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                Divider()
                    .frame(height: 60)
                
                VStack(alignment: .leading) {
                    Text("52W H \(stock.metric.fiftyTwoWeekHigh.map {String($0)} ?? "-")")
                    Text("52W L \(stock.metric.fiftyTwoWeekLow.map {String($0)} ?? "-")")
                    Text("Avg Vol \(stock.metric.tenDayAverageTradingVolume.map {String($0)} ?? "-")")
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .padding(.vertical, 4)
        }
        .frame(height: 60)
    }
}

#Preview {
    MetricsScrollView(stock: Stock(
        currentPrice: Stock.Price(
            c: 172.15,
            d: 1.23,
            dp: 0.72,
            h: 173.0,
            l: 170.5,
            o: 171.0,
            pc: 170.92
        ),
        profile: Stock.Profile(
            name: "Apple Inc.",
            ticker: "AAPL",
            exchange: "NASDAQ",
            currency: "USD",
            ipo: "1980-12-12",
            marketCapitalization: 2500000,
            shareOutstanding: 16700,
            logo: "https://logo.clearbit.com/apple.com",
            finnhubIndustry: "Technology"
        ),
        historicalData: nil,
        news: [],
        metric: Stock.Metric(peNormalizedAnnual: 1, fiftyTwoWeekHigh: 1, fiftyTwoWeekLow: 1, tenDayAverageTradingVolume: 1, volume: 1)
    ))
}
