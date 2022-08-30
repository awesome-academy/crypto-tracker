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

    func createPortfolioCoinCoinDataObject (coin: BaseCoin, amount: String) -> PortfolioCoin {
        let portfolioCoin = PortfolioCoin(context: context)
        portfolioCoin.uuid = coin.uuid
        portfolioCoin.name = coin.name
        portfolioCoin.image = coin.iconUrl
        portfolioCoin.symbol = coin.symbol
        portfolioCoin.amount = amount
        return portfolioCoin
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

    func getAllPorfolioCoin(completion: @escaping (Error?, [PortfolioCoin]?) -> Void) {
        var coinList = [PortfolioCoin]()
        do {
            let request = PortfolioCoin.fetchRequest() as NSFetchRequest<PortfolioCoin>
            request.returnsObjectsAsFaults = false
            coinList = try context.fetch(request)
            completion(nil, coinList)
        } catch {
            completion(error, nil)
        }
    }

    func getTotalValueInvestment(completion: @escaping (Error) -> Void) -> Double {
        var coinList = [PortfolioCoin]()
        var value = 0.0
        do {
            coinList = try context.fetch(PortfolioCoin.fetchRequest())
        } catch {
            completion(error)
        }
        for coin in coinList {
            let priceCoin = coin.price.replacingOccurrences(of: ",", with: "")
            value += Double(priceCoin) ?? 0.0
        }
        return value
    }

    func removeCoin<T: NSManagedObject>(myListObject: T, completion: @escaping (Error) -> Void) {
        context.delete(myListObject)
        do {
            try context.save()
        } catch {
            completion(error)
        }
    }

    func addCoin<T: NSManagedObject>(myListObject: T, completion: @escaping (Error) -> Void) {
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

    func checkPortfolioCoinExist(uuid: String, completion: @escaping (Error) -> Void) -> Bool {
        var items = [PortfolioCoin]()
        let request = PortfolioCoin.fetchRequest() as NSFetchRequest<PortfolioCoin>
        let pred = NSPredicate(format: "uuid CONTAINS %@", uuid)
        request.predicate = pred
        do {
            items = try context.fetch(request)
        } catch {
            completion(error)
        }
        return !items.isEmpty
    }

    func updateCoin(uuid: String, amount: String, coin: BaseCoin, completion: @escaping (Error) -> Void) {
        let request = PortfolioCoin.fetchRequest() as NSFetchRequest<PortfolioCoin>
        let pred = NSPredicate(format: "uuid CONTAINS %@", uuid)
        request.predicate = pred
        do {
            let items = try context.fetch(request)
            if !items.isEmpty {
                guard let priceCoin = coin.price else { return }
                let amountBefore = (Double(items[0].amount.replacingOccurrences(of: ",", with: "")) ?? 1.0 )
                let sumAmount = (Double(amount) ?? 1.0) + amountBefore
                let priceBefore = Double(items[0].price.replacingOccurrences(of: ",", with: "")) ?? 1.0
                let priceAdd = (Double(amount) ?? 1.0) * (Double(priceCoin) ?? 1.0)
                let price =  priceAdd + priceBefore
                items[0].setValue(String(sumAmount).convertToNumber(), forKey: "amount")
                items[0].setValue(String(price).convertToNumber(), forKey: "price")
            }
        } catch {
            completion(error)
        }
    }
}
