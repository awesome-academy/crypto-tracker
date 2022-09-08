//
//  PortfolioViewControllerTest.swift
//  CryptoTrackerTests
//
//  Created by Huy Hà on 9/5/22.
//

import XCTest
@testable import CryptoTracker

final class PortfolioViewControllerTest: XCTestCase {
    var sut: PortfolioViewController!

    override func setUpWithError() throws {
        sut = PortfolioViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.addButtonPressed(UIButton())
        sut.dismissKeyBoard()
        sut.portfolioTableView.select(row: 1)
        sut.portfolioCoin =  BaseCoin(uuid: "Qwsogvtv82FCd",
                                      iconUrl: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg",
                                      name: "Bitcoin",
                                      symbol: "BTC",
                                      price: "19123.13")
        sut.searchCoinButtonPressed(UIButton())
        sut.saveCoinData()
        sut.portfolioTableView.select(row: 0)

    }

    func testNextExample() throws {
        sut.viewDidLoad()
        sut.addButtonPressed(UIButton())
        sut.dismissKeyBoard()
        sut.portfolioCoin =  BaseCoin(uuid: "Qjdajdjkd12",
                                      iconUrl: "https://cdn.coinranking.com/jkDf8sQbY/usdc.svg",
                                      name: "USDC",
                                      symbol: "USDC",
                                      price: "12")
        sut.searchCoinButtonPressed(UIButton())
        sut.saveCoinData()
        sut.portfolioTableView.select(row: 0)
    }

    func testNextExamplexxx() throws {
        sut.viewDidLoad()
        sut.portfolioTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
