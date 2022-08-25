//
//  HistoryStats.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/23/22.
//

import Foundation

struct PriceHistory: Codable {
    let change: String
    let history: [History]
}

struct History: Codable {
    let price: String?
    let timestamp: Double
}
