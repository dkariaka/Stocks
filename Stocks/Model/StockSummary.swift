//
//  StockSummary.swift
//  Stocks
//
//  Created by Дмитрий К on 27.05.2025.
//

import Foundation

struct StockSummary: Codable, Identifiable {
    
    var id: String { profile.ticker }
    
    var currentPrice: Price
    var profile: Profile
    
    struct Profile: Codable {
        var name: String
        var ticker: String
    }
    
    struct Price: Codable {
        var c: Double //current price
        var d: Double //change
        var dp: Double //percent change
    }
}
