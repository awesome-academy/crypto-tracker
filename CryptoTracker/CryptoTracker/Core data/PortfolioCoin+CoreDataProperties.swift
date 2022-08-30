//
//  PortfolioCoin+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/28/22.
//
//

import Foundation
import CoreData

extension PortfolioCoin {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioCoin> {
        return NSFetchRequest<PortfolioCoin>(entityName: "PortfolioCoin")
    }

    @NSManaged public var uuid: String
    @NSManaged public var symbol: String
    @NSManaged public var name: String
    @NSManaged public var image: String
    @NSManaged public var amount: String
    @NSManaged public var price: String

}

extension PortfolioCoin: Identifiable {

}
