//
//  StockDetailView.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import SwiftUI

struct StockDetailView: View {
    @StateObject private var viewModel = StockDetailViewModel()
    let stock: Stock
    @Environment(\.dismiss) private var dismiss
    @State private var selectedInterval: ChartInterval = .oneMonth
    @Binding var didModifyFavorites: Bool
    

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            if viewModel.isLoading {
//                ProgressView()
//                    .frame(maxWidth: .infinity)
//            } else if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .padding()
//            } else {
                DetailHeaderView(stock: stock,
                                 addToFavorites: {
                                    await viewModel.addToFavorites()
                                    didModifyFavorites = true
                                 },
                                 dismiss: {
                                    dismiss()
                                 })
                ChartIntervalSelector(selectedInterval: $selectedInterval)
                VStack {
                    if !viewModel.chartData.isEmpty {
                        StockChartView(dataPoints: viewModel.chartData, interval: .oneMonth)
                            .frame(height: 180)
                    } else {
                        Text("No chart data available")
                    }
                }
                .onChange(of: selectedInterval) {
                    Task {
                        await viewModel.fetchChart(for: stock.profile.ticker, interval: selectedInterval)
                    }
                }
                MetricsScrollView(stock: stock)
                Spacer()
                NewsList(news: stock.news)
            //}
        }
        .task {
            await viewModel.fetchStock(for: stock.profile.ticker)
            await viewModel.fetchChart(for: stock.profile.ticker, interval: selectedInterval)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StockDetailView(stock: Stock(
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
        news: [
            Stock.News(
                category: "Technology",
                datetime: Int(Date().timeIntervalSince1970),
                headline: "Apple announces new product",
                id: 1,
                image: "",
                related: "AAPL",
                source: "Reuters",
                summary: "Apple unveiled its latest iPhone model.",
                url: ""
            )
        ],
        metric: Stock.Metric(peNormalizedAnnual: 1, fiftyTwoWeekHigh: 1, fiftyTwoWeekLow: 1, tenDayAverageTradingVolume: 1, volume: 1) 
    ),
                    didModifyFavorites: .constant(false))
}
