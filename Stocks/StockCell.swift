//
//  StockCell.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import SwiftUI

struct StockCell: View {
    let stock: Stock

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: stock.profile.logo)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(stock.profile.ticker)
                    .font(.headline)
                Text(stock.profile.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.2f", stock.currentPrice.c))
                    .font(.headline)
                Text(String(format: "%.2f%%", stock.currentPrice.dp))
                    .font(.subheadline)
                    .foregroundColor(stock.currentPrice.dp >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

#Preview {
    StockCell(stock: Stock(
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
