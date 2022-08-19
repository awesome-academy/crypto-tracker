//
//  APIRepository.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/16/22.
//

import Foundation

final class APIRepository {
    func getListCoin(url: String, method: HTTPMethod, completion: @escaping ([Coin]?, Error?) -> Void) {
        APIService.shared.requestData(urlString: url,
                                      method: method.rawValue,
                                      expecting: Response<CoinList>.self) { [weak self] result in
            switch result {
            case .success(let result):
                completion(result.data.coins, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func getListSearchCoin(url: String, method: HTTPMethod, completion: @escaping ([BaseCoin]?, Error?) -> Void) {
        APIService.shared.requestData(urlString: url,
                                      method: method.rawValue,
                                      expecting: Response<SearchCoinList>.self) { [weak self] result in
            switch result {
            case .success(let result):
                completion(result.data.coins, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
