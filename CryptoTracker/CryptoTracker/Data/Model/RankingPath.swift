//
//  Ranking.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/12/22.
//

import Foundation

enum RankingPath: String {
    case topCoin = "v2/coins?orderBy=price&limit=10"
    case topChange = "v2/coins?orderBy=change&limit=10"
    case top24Volume = "v2/coins?orderBy=24hVolume&limit=10"
    case topMarketCap = "v2/coins?orderBy=marketCap&limit=10"
}
