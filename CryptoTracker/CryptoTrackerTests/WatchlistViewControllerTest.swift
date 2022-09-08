//
//  WatchlistViewControllerTest.swift
//  CryptoTrackerTests
//
//  Created by Huy Hà on 9/5/22.
//

import XCTest
@testable import CryptoTracker

final class WatchlistViewControllerTest: XCTestCase {
    var sut: WatchListViewController!
    override func setUpWithError() throws {
        sut = WatchListViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.watchlistTableView.select(row: 1)
        sut.viewWillAppear(true)
        sut.openSearchScreen(UIButton())
    }
}
