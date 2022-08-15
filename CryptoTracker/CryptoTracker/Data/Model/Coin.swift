//
//  Coin.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import Foundation
import UIKit

struct CoinList: Codable {
    let coins: [Coin]
}

struct Coin: Codable {
    let uuid: String
    let sympol: String
    let description: String
    let iconURL: String?
    let websiteUrl: String?
    let marketCap: String
    let price: String
    let change: String
    let rank: Int
    let volumePerDay: String

    private enum CodingKeys: String, CodingKey {
        case uuid
        case sympol
        case description
        case iconURL
        case websiteUrl
        case marketCap
        case price
        case change
        case rank
        case volumePerDay = "24hVolume"
    }
}
