//
//  NewsList.swift
//  Stocks
//
//  Created by Дмитрий К on 15.05.2025.
//

import SwiftUI

struct NewsList: View {
    var news: [Stock.News]

    var body: some View {
        VStack {
            if news.isEmpty {
                Text("No news")
            } else {
                List {
                    ForEach(news) { article in
                        NewsCell(news: article)
                            .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                            .background(Color(.systemBackground))
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

#Preview {
    NewsList(news: [
        Stock.News(
            category: "Business",
            datetime: 1672505600,
            headline: "Apple Stock Rises on New Product Launch",
            id: 1,
            image: "https://example.com/image.jpg",
            related: "AAPL",
            source: "Bloomberg",
            summary: "Apple shares climbed today after the company announced a new product...",
            url: "https://example.com/full-article"
        ),
        Stock.News(
            category: "Business",
            datetime: 1672505600,
            headline: "Apple Stock Rises on New Product Launch",
            id: 1,
            image: "https://example.com/image.jpg",
            related: "AAPL",
            source: "Bloomberg",
            summary: "Apple shares climbed today after the company announced a new product...",
            url: "https://example.com/full-article"
        )])
}
