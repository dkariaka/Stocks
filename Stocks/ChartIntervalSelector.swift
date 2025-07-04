//
//  ChartIntervalSelector.swift
//  Stocks
//
//  Created by Дмитрий К on 29.06.2025.
//

import SwiftUI

struct ChartIntervalSelector: View {
    @Binding var selectedInterval: ChartInterval
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(ChartInterval.allCases) { interval in
                    Button {
                        selectedInterval = interval
                    } label: {
                        Text(interval.rawValue)
                            .fontWeight(selectedInterval == interval ? .bold : .regular)
                            .foregroundColor(.primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedInterval == interval ? Color.gray : Color.clear)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 30)
    }
}

#Preview {
    struct Wrapper: View {
        @State private var selectedInterval: ChartInterval = .oneMonth

        var body: some View {
            ChartIntervalSelector(selectedInterval: $selectedInterval)
                .padding()
        }
    }

    return Wrapper()
}
