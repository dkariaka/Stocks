//
//  ContentView.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StockListViewModel()
    @State private var didModifyFavorites = false

    var body: some View {
        NavigationStack {
            StockList(stocks: $viewModel.favoriteStocks,
                      onDelete: { indexSet in
                        Task {
                            await viewModel.deleteStocks(at: indexSet)
                        }
                      },
                      onSelect: { stock in
                          viewModel.selectedStock = stock
                      })
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .navigationTitle("Stocks")
                .searchable(text: $viewModel.searchText)
                .onSubmit(of: .search) {
                    Task {
                        await viewModel.fetchStock(for: viewModel.searchText.uppercased())
                    }
                }
                .task {
                    if viewModel.favoriteStocks.isEmpty {
                        await viewModel.fetchFavoriteStocks()
                    }
                }
                .sheet(item: $viewModel.selectedStock, onDismiss: {
                    if didModifyFavorites {
                        Task {
                            await viewModel.fetchFavoriteStocks()
                            didModifyFavorites = false 
                        }
                    }
                }) { stock in
                    StockDetailView(stock: stock, didModifyFavorites: $didModifyFavorites)
                }
        }
    }
}

#Preview {
    ContentView()
}
