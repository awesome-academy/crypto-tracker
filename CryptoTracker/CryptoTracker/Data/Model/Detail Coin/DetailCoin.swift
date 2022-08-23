//
//  DetailCoin.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/23/22.
//

import Foundation

struct DataDetailCoin: Codable {
    let coin: DetailCoin
}

struct DetailCoin: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let iconUrl: String
    let description: String
    let links: [Link]
    let supply: Supply
    let volumePerDay: String
    let marketCap: String
    let price: String?
    let change: String?
    let rank: Int
    let btcPrice: String
    let allTimeHigh: History

    private enum CodingKeys: String, CodingKey {
        case uuid
        case symbol
        case name
        case iconUrl
        case description
        case links
        case supply
        case volumePerDay = "24hVolume"
        case marketCap
        case price
        case btcPrice
        case change
        case rank
        case allTimeHigh
    }
}
