//
//  CoinDataRepository.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/25/22.
//

import UIKit
import CoreData

final class CoinDataRepository {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext()

    func createCoinDataObject (coin: DetailCoin) -> WatchlistCoin {
        let watchlistCoin = WatchlistCoin(context: context)
        watchlistCoin.uuid = coin.uuid
        watchlistCoin.price = coin.price
        watchlistCoin.name = coin.name
        watchlistCoin.image = coin.iconUrl
        watchlistCoin.sympol = coin.symbol
        return watchlistCoin
    }

    func getAll(completion: @escaping (Error) -> Void) -> [WatchlistCoin] {
        var coinList = [WatchlistCoin]()
        do {
            coinList = try context.fetch(WatchlistCoin.fetchRequest())
        } catch {
            completion(error)
        }
        return coinList
    }

    func removeCoin(myListObject: WatchlistCoin, completion: @escaping (Error) -> Void) {
        context.delete(myListObject)
        do {
            try context.save()
        } catch {
            completion(error)
        }
    }

    func addCoin(myListObject: WatchlistCoin, completion: @escaping (Error) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                completion(error)
            }
        }
    }

    func checkCoinExist(uuid: String, completion: @escaping (Error) -> Void) -> Bool {
        var items = [WatchlistCoin]()
        let request = WatchlistCoin.fetchRequest() as NSFetchRequest<WatchlistCoin>
        let pred = NSPredicate(format: "uuid CONTAINS %@", uuid)
        request.predicate = pred
        do {
            items = try context.fetch(request)
        } catch {
            completion(error)
        }
        return !items.isEmpty
    }
}
