//
//  Coin.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import UIKit

struct Coin: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let iconUrl: String
    let marketCap: String?
    let price: String
    let change: String
    let rank: Int
    let volumePerDay: String

    private enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case symbol
        case iconUrl
        case marketCap
        case price
        case change
        case rank
        case volumePerDay = "24hVolume"
    }
}
