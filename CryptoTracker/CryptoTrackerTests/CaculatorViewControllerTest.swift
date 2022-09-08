//
//  CaculatorViewControllerTest.swift
//  CryptoTrackerTests
//
//  Created by Huy Hà on 9/5/22.
//

import XCTest
@testable import CryptoTracker

final class CaculatorViewControllerTest: XCTestCase {
    var sut: CalculatorViewController!

    override func setUpWithError() throws {
        sut = CalculatorViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.targetButtonPressed(UIButton())
        sut.baseCoinButtonPressed(UIButton())
        sut.exchangeButton(UIButton())
        sut.dismissKeyBoard()
    }
}
