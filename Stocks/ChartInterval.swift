//
//  ChartInterval.swift
//  Stocks
//
//  Created by Дмитрий К on 29.06.2025.
//

import Foundation

enum ChartInterval: String, CaseIterable, Identifiable {

    case oneDay = "1D"
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case yearToDate = "YTD"
    case oneYear = "1Y"
    
    var id: String { rawValue }
    
    var appInterval: String {
        switch self {
        case .oneDay: return "15min"
        case .oneWeek: return "2h"
        case .oneMonth: return "1day"
        case .threeMonths: return "1day"
        case .sixMonths: return "1week"
        case .yearToDate: return "1week"
        case .oneYear: return "1week"
        }
    }
    
    var outputSize: Int {
        switch self {
        case .oneDay: return 96
        case .oneWeek: return 84
        case .oneMonth: return 30
        case .threeMonths: return 90
        case .sixMonths: return 24
        case .yearToDate: return 48
        case .oneYear: return 48
        }
    }
}
