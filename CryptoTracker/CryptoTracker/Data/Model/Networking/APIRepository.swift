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

    func getDetailCoin(uuid: String, method: HTTPMethod, completion: @escaping (DetailCoin?, Error?) -> Void) {
        APIService.shared.requestData(urlString: Network.shared.getDetailURL(uuid: uuid),
                                      method: method.rawValue,
                                      expecting: Response<DataDetailCoin>.self) { [weak self] result in
            switch result {
            case .success(let result):
                completion(result.data.coin, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func getHistoryStats(uuid: String, time: TimeSegment.RawValue,
                         method: HTTPMethod,
                         completion: @escaping ([History]?, Error?) -> Void) {
        APIService.shared.requestData(urlString: Network.shared.getHistoryPriceURL(uuid: uuid, time: time),
                                      method: method.rawValue,
                                      expecting: Response<PriceHistory>.self) { [weak self] result in
            switch result {
            case .success(let result):
                completion(result.data.history, nil)
            case .failure(let error):
                completion(nil, error)

            }
        }
    }
}
