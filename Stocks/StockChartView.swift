//
//  StockChartView.swift
//  Stocks
//
//  Created by Дмитрий К on 28.06.2025.
//

import SwiftUI
import DGCharts

enum ChartInterval {
    case oneDay, oneWeek, oneMonth, threeMonths, sixMonths, oneYear, max
}

final class DateValueFormatter: AxisValueFormatter {
    private let dateFormatter: DateFormatter
    private let interval: ChartInterval

    init(interval: ChartInterval) {
        self.interval = interval
        self.dateFormatter = DateFormatter()

        switch interval {
        case .oneDay:
            dateFormatter.dateFormat = "HH:mm"
        case .oneWeek, .oneMonth:
            dateFormatter.dateFormat = "d MMM"
        case .threeMonths, .sixMonths, .oneYear:
            dateFormatter.dateFormat = "MMM yyyy"
        case .max:
            dateFormatter.dateFormat = "yyyy"
        }
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}


struct StockChartView: UIViewRepresentable {
    let dataPoints: [ChartPoint]
    let interval: ChartInterval

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

        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .linear
        dataSet.lineWidth = 2
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.2


        if let first = dataPoints.last?.close, let last = dataPoints.first?.close {
            let isGrowing = first < last
            let color = isGrowing ? UIColor.systemGreen : UIColor.systemRed
            dataSet.setColor(color)
            dataSet.fillColor = color
        }

        uiView.data = LineChartData(dataSet: dataSet)
        uiView.xAxis.valueFormatter = DateValueFormatter(interval: interval)
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

    return StockChartView(dataPoints: testPoints, interval: .oneMonth)
        .frame(height: 180)
}



