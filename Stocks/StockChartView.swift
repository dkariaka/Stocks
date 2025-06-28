//
//  StockChartView.swift
//  Stocks
//
//  Created by Дмитрий К on 28.06.2025.
//

import SwiftUI
import DGCharts

struct StockChartView: UIViewRepresentable {
    let dataPoints: [ChartPoint]

    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.animate(xAxisDuration: 0.5)
        chartView.setScaleEnabled(false)
        return chartView
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {
        let entries = dataPoints.map { ChartDataEntry(x: $0.date.timeIntervalSince1970, y: $0.close) }

        let dataSet = LineChartDataSet(entries: entries, label: "Price")
        dataSet.colors = [.systemBlue]
        dataSet.circleColors = [.systemBlue]
        dataSet.circleRadius = 3
        dataSet.drawValuesEnabled = false

        let data = LineChartData(dataSet: dataSet)
        uiView.data = data
    }
}

#Preview {
    let testPoints = [
        ChartPoint(date: Date().addingTimeInterval(-3600 * 24 * 4), close: 154),
        ChartPoint(date: Date().addingTimeInterval(-3600 * 24 * 3), close: 157),
        ChartPoint(date: Date().addingTimeInterval(-3600 * 24 * 2), close: 155),
        ChartPoint(date: Date().addingTimeInterval(-3600 * 24), close: 159),
        ChartPoint(date: Date(), close: 158)
    ]

    return StockChartView(dataPoints: testPoints)
        .frame(height: 300)
}



