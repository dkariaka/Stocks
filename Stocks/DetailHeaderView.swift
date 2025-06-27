//
//  DetailHeaderView.swift
//  Stocks
//
//  Created by Дмитрий К on 27.06.2025.
//

import SwiftUI

struct DetailHeaderView: View {
    let stock: Stock
    let addToFavorites: () async -> Void
    let dismiss: () -> Void
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(stock.profile.ticker)
                .font(.system(size: 28, weight: .bold))
            Text(stock.profile.name)
                .font(.system(size: 15))
            Spacer()
            CircleButton(systemIconName: "plus") {
                await addToFavorites()
            }
            CircleButton(systemIconName: "xmark") {
                dismiss()
            }
        }
        .padding(.top, 20)
        Divider()
        HStack {
            Text(String(format: "%.2f", stock.currentPrice.c))
                .font(.title2)
            Text(String(format: "%.2f%%", stock.currentPrice.dp))
                .font(.subheadline)
                .foregroundColor(stock.currentPrice.dp >= 0 ? .green : .red)
            Spacer()
        }
        Text(stock.profile.exchange + " · " + stock.profile.currency)
        Divider()
    }
}

#Preview {
    DetailHeaderView(stock: Stock(
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
    ), addToFavorites: {}, dismiss: {})
}
