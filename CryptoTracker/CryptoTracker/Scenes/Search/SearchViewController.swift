//
//  SearchViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/15/22.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet private weak var searchCoinTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchLabel: UILabel!

    var completionUuid: ((String) -> Void)?
    private var listSearchCoin = [BaseCoin]()
    private var apiRepository = APIRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }

    private func configViews () {
        searchCoinTableView.keyboardDismissMode = .interactive
        searchCoinTableView.separatorStyle = .none
        searchCoinTableView.delegate = self
        searchCoinTableView.dataSource = self
        searchCoinTableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "cell")
        searchBar.delegate = self
    }

    @IBAction private func cancelPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    private func loadSearchDataFromAPI (urlRequest: String, message: Constants) {
        apiRepository.getListSearchCoin(url: urlRequest,
                                        method: .get) { [unowned self] searchCoins, error in
            guard error == nil, let searchCoins = searchCoins else {
                self.showAlert(title: "Alert", message: error?.localizedDescription ?? message.rawValue)
                return
            }
            self.listSearchCoin = searchCoins
            DispatchQueue.main.async {
                self.searchCoinTableView.reloadData()
                searchLabel.text = listSearchCoin.count != 0 ? "" : message.rawValue
            }
        }
    }

    private func pushToDetailViewController (index: Int) {
        let detailVC = DetailViewController()
        detailVC.setUuid(uuid: listSearchCoin[index].uuid)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func popToPreviousViewController (index: Int) {
        navigationController?.popViewController(animated: true)
        completionUuid?(listSearchCoin[index].uuid)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CoinCell else {
            return  UITableViewCell()
        }
        cell.setDataCell(coin: listSearchCoin[indexPath.row], error: .untrackedPrice)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchCoinTableView.deselectRow(at: indexPath, animated: false)
        guard let previousScreen = navigationController?.previousViewController else {
            return
        }
        switch true {
        case previousScreen.isKind(of: HomeViewController.self):
            pushToDetailViewController(index: indexPath.row)
        case previousScreen.isKind(of: WatchListViewController.self):
            pushToDetailViewController(index: indexPath.row)
        case previousScreen.isKind(of: CalculatorViewController.self):
            popToPreviousViewController(index: indexPath.row)
        case previousScreen.isKind(of: PortfolioViewController.self):
            popToPreviousViewController(index: indexPath.row)
        default:
            return
        }
    }
}
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSearchCoin.count
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        self.loadSearchDataFromAPI(urlRequest: Network.shared.getSearchURL(name: text), message: .searchResultError )
        searchBar.resignFirstResponder()
    }
}
