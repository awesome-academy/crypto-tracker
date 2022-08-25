//
//  WatchlistCoin+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/26/22.
//
//

import Foundation
import CoreData

extension WatchlistCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchlistCoin> {
        return NSFetchRequest<WatchlistCoin>(entityName: "WatchlistCoin")
    }

    @NSManaged public var name: String
    @NSManaged public var uuid: String
    @NSManaged public var price: String?
    @NSManaged public var sympol: String
    @NSManaged public var image: String

}

extension WatchlistCoin: Identifiable {

}
