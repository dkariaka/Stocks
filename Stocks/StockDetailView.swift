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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                HStack(alignment: .firstTextBaseline) {
                    Text(stock.profile.ticker)
                        .font(.system(size: 28, weight: .bold))
                    Text(stock.profile.name)
                        .font(.system(size: 15))
                    Spacer()
                    Button {
                        Task {
                            await viewModel.addToFavorites()
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(.systemGray5))
                            )
                    }
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(.systemGray5))
                            )
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
                //StockLineChartView(stock: stock)
                
                
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
                Spacer()
                NewsList(ticker: stock.profile.ticker)
            }
        }
        .task {
            await viewModel.fetchStock(for: stock.profile.ticker)
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
        historicalData: nil,
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
    ))
}
