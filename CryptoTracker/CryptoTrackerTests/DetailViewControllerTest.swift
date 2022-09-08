//
//  DetailViewControllerTest.swift
//  CryptoTrackerTests
//
//  Created by Huy Hà on 9/5/22.
//

import XCTest
@testable import CryptoTracker

final class DetailViewControllerTest: XCTestCase {
    var sut: DetailViewController!

    override func setUpWithError() throws {
        sut = DetailViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.setUuid(uuid: "Qwsogvtv82FCd")
        let coin = DetailCoin(uuid: "ADDN",
                              symbol: "Btc",
                              name: "BIt",
                              iconUrl: "facebook.com",
                              description: "bit is oke",
                              links: [Link(name: "ok.com", type: "bn", url: "ok.com")],
                              supply: Supply(total: "234", circulating: "123"),
                              volumePerDay: "",
                              marketCap: "",
                              price: "123",
                              change: "123.12",
                              rank: 2,
                              btcPrice: "1.1",
                              allTimeHigh: History(price: "123", timestamp: 12.2))

        sut.viewDidLoad()
        sut.detailCoin = coin
        sut.viewWillAppear(true)
        sut.setDataDetailViewController()
        sut.favouriteButtonPressed(UIButton())
        sut.backButtonPressed(UIButton())
        sut.timeSegmentPressed(UISegmentedControl())
    }

    func testNextExample() throws {
        sut.setUuid(uuid: "dhksjfdf")
        let coin = DetailCoin(uuid: "QWNDNDX",
                              symbol: "Btcd",
                              name: "BItd",
                              iconUrl: "faceboo.com",
                              description: "bit is oke",
                              links: [Link(name: "ok.com", type: "bn", url: "ok.com")],
                              supply: Supply(total: "234", circulating: "123"),
                              volumePerDay: "",
                              marketCap: "",
                              price: "12.2",
                              change: "12.22",
                              rank: 2,
                              btcPrice: "1.1",
                              allTimeHigh: History(price: "123", timestamp: 12.2))
        sut.isFavorite = true
        sut.viewDidLoad()
        sut.detailCoin = coin
        sut.viewWillAppear(true)
        sut.setDataDetailViewController()
        sut.favouriteButtonPressed(UIButton())
        sut.backButtonPressed(UIButton())
        sut.timeSegmentPressed(UISegmentedControl())
    }

    func testChart() throws {
        sut.setUuid(uuid: "skdjfkf")
        sut.historyPrices = [History(price: "12.2", timestamp: 12.0), History(price: "20.9", timestamp: 12.2)]
        sut.loadDataChartDetailViewController()
    }
}
