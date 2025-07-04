//
//  StockList.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import SwiftUI

struct StockList: View {
    var stocks: [Stock]
    var onDelete: (IndexSet) -> Void
    var onSelect: (Stock) -> Void

    var body: some View {
        VStack {
            if stocks.isEmpty {
                Text("No favorite stocks")
            } else {
                List {
                    Section(header: Text("My Symbols")) {
                        ForEach(stocks, id: \.profile.ticker) { stock in
                            Button(action: {
                                onSelect(stock)
                            }) {
                                StockCell(stock: stock)
                            }
                        }
                        .onDelete(perform: onDelete)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}


#Preview {
    StockList(
        stocks: [
            Stock(
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
                news: [],
                metric: Stock.Metric(peNormalizedAnnual: 1, fiftyTwoWeekHigh: 1, fiftyTwoWeekLow: 1, tenDayAverageTradingVolume: 1, volume: 1)
            ),
            Stock(
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
                news: [],
                metric: Stock.Metric(peNormalizedAnnual: 1, fiftyTwoWeekHigh: 1, fiftyTwoWeekLow: 1, tenDayAverageTradingVolume: 1, volume: 1)
            )
        ],
        onDelete: { _ in },
        onSelect: { _ in }
    )
}
