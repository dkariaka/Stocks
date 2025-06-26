//
//  NewsCell.swift
//  Stocks
//
//  Created by Дмитрий К on 14.05.2025.
//

import SwiftUI

struct NewsCell: View {
    
    let news: Stock.News
    
    var body: some View {

        VStack(alignment: .leading) {
            Text(news.headline)
                .font(.subheadline)
                .bold()
            Text(news.summary)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(Date(timeIntervalSince1970: TimeInterval(news.datetime)), format:.dateTime)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }

}

#Preview {
    NewsCell(news: Stock.News(
        category: "Business",
        datetime: 1672505600,
        headline: "Apple Stock Rises on New Product Launch",
        id: 1,
        image: "https://example.com/image.jpg",
        related: "AAPL",
        source: "Bloomberg",
        summary: "Apple shares climbed today after the company announced a new product...",
        url: "https://example.com/full-article"
    ))
}
