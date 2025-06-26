//
//  StockLineChartView.swift
//  Stocks
//
//  Created by Дмитрий К on 11.06.2025.
//

import SwiftUI
import DGCharts

struct StockLineChartView: UIViewRepresentable {
    //let entries: [ChartDataEntry]
    private let stock: Stock

    func makeUIView(context: Context) -> LineChartView {
        let chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.xAxis.valueFormatter = DateValueFormatter()
        return chart
    }

    func updateUIView(_ chartView: LineChartView, context: Context) {
        guard let historicalData = stock.historicalData else { return }

        let entries = zip(historicalData.t, historicalData.c).map { (timestamp, closePrice) in
            ChartDataEntry(x: Double(timestamp), y: closePrice)
        }

        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.mode = LineChartDataSet.Mode.cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        dataSet.setColor(UIColor.systemBlue)
        dataSet.drawValuesEnabled = false

        let data = LineChartData(dataSet: dataSet)
        chartView.data = data

        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.labelRotationAngle = -45
    }

}

class DateValueFormatter: AxisValueFormatter {
    private let formatter: DateFormatter

    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // формат вида Jun 9
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return formatter.string(from: date)
    }
}
