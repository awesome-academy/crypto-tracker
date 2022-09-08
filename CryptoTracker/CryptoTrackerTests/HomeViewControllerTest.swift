//
//  HomeViewControllerTest.swift
//  CryptoTrackerTests
//
//  Created by Huy Hà on 9/5/22.
//

import XCTest
@testable import CryptoTracker

final class HomeViewControllerTest: XCTestCase {

    var sut: HomeViewController!

    override func setUpWithError() throws {
        sut = HomeViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.openRankingOptions(UIButton())
        sut.openSearchController(UIButton())
        sut.rankButtonPressed(sut.rankedByPriceButton)
        sut.rankButtonPressed(sut.rankedByChangeButton)
        sut.rankButtonPressed(sut.rankedByMarketCapButton)
        sut.rankButtonPressed(sut.rankedBy2VolumePerDayButton)
        sut.coinTableView.reloadData()
        sut.coinTableView.select(row: 1)
    }
}

extension UITableView {
    func select(row: Int) {
        delegate?.tableView?(self, didSelectRowAt: IndexPath(row: row, section: 0))
    }
}
