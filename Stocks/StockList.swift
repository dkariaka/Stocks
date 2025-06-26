//
//  StockList.swift
//  Stocks
//
//  Created by Дмитрий К on 08.05.2025.
//

import SwiftUI

struct StockList: View {
    @ObservedObject var viewModel: StockListViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List {
                    Section(header: Text("My Symbols")) {
                        ForEach(viewModel.favoriteStocks, id: \.profile.ticker) { stock in
                            Button(action: {
                                viewModel.selectedStock = stock
                            }) {
                                StockCell(stock: stock)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            Task {
                                await viewModel.deleteStocks(at: indexSet)
                            }
                        })
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchFavoriteStocks()
            }
        }
    }
}


#Preview {
    StockList(viewModel: StockListViewModel())
}
