//
//  LineChartViewRepresentable.swift
//  Stocks
//
//  Created by Дмитрий К on 11.06.2025.
//

import SwiftUI
import DGCharts

struct LineChartViewRepresentable: UIViewRepresentable {
    let entries: [ChartDataEntry]
    
    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 0.5)
        return chartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries, label: "Price")
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        dataSet.setColor(.systemBlue)
        dataSet.fillAlpha = 0.3
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = false
        
        uiView.data = LineChartData(dataSet: dataSet)
    }
}
