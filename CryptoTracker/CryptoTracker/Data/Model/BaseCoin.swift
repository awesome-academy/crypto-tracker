//
//  BaseCoin.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/12/22.
//

import Foundation

struct BaseCoin: Codable {
    let uuid: String
    let iconUrl: String
    let name: String
    let symbol: String
    let price: String?

    private enum Codingkeys: String, CodingKey {
        case uuid
        case iconUrl
        case name
        case symbol
        case price
    }
}
