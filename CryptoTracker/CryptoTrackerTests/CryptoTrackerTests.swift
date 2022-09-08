//
//  CryptoTrackerTests.swift
//  CryptoTrackerTests
//
//  Created by Huy Hà on 8/10/22.
//

import XCTest
@testable import CryptoTracker

final class CryptoTrackerTests: XCTestCase {
    var coinDataRepository:  CoinDataRepository!
    override func setUpWithError() throws {
        coinDataRepository =  CoinDataRepository()

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        coinDataRepository = nil
    }
}
