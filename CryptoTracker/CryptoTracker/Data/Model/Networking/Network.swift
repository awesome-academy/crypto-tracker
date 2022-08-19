//
//  Network.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import Foundation

struct Network {
    static let shared = Network()

    private init () {}

    private let baseUrl = "https://api.coinranking.com/"

    func getCoinsURL(path: RankingPath) -> String {
        return "\(baseUrl)\(path.rawValue)"
    }

    func getDetailURL(uuid: String) -> String {
        return "\(baseUrl)/coin/\(uuid)"
    }

    func getSearchURL(name: String) -> String {
        return "\(baseUrl)/search-suggestions?query=\(name)"
    }

    func getExchangeRates(base: String, target: String) -> String {
        return "\(baseUrl)/coin/\(base)/price?referenceCurrencyUuid=\(target)"
    }
}
