//
//  NewsList.swift
//  Stocks
//
//  Created by Дмитрий К on 15.05.2025.
//

import SwiftUI

struct NewsList: View {
    let ticker: String
    @StateObject private var viewModel = StockDetailViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if let news = viewModel.stock?.news, !news.isEmpty {
                List {
                    ForEach(news) { article in
                        NewsCell(news: article)
                            .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                            .background(Color(.systemBackground)) 
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                Text("No news")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .task {
            await viewModel.fetchStock(for: ticker)
        }
    }
}

#Preview {
    NewsList(ticker: "AAPL")
}
