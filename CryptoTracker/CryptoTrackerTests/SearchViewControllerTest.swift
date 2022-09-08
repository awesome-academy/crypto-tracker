//
//  SearchViewControllerTest.swift
//  CryptoTrackerTests
//
//  Created by Huy Hà on 9/5/22.
//

import XCTest
@testable import CryptoTracker

final class SearchViewControllerTest: XCTestCase {
    var sut: SearchViewController!

    override func setUpWithError() throws {
        sut = SearchViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testSearch() throws {
        sut.viewDidLoad()
        sut.cancelPressed(UIButton())
        guard let tableView = sut.searchCoinTableView else { return }
        let promise = expectation(description: "Status Code: 200")
        let endpoint = Network.shared.getSearchURL(name: "Bit")
        sut.searchBar.text = "BNB"
        sut.searchBarSearchButtonClicked(UISearchBar())
        let url = URL(string: endpoint)
        guard let urlPath = url else {
            return
        }
        var request = URLRequest(url: urlPath)
        request.httpMethod = "GET"
        request.setValue("coinrankingd7fb02e15d8956a6cf1dc6b6bce9aa9e4de9891af1d1655d", forHTTPHeaderField: "x-access-token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(Response<SearchCoinList>.self, from: data)
                promise.fulfill()
            } catch {
                XCTFail("Status Code: \(String(describing: response))")
            }
        }
        task.resume()
        wait(for: [promise], timeout: 10)
        tableView.reloadData()
        tableView.select(row: 1)
        XCTAssertNotNil(sut.pushToDetailViewController(index: 1))
        XCTAssertNotNil(sut.popToPreviousViewController(index: 1))
    }
}
