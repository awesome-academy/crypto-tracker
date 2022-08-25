//
//  WatchListViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/25/22.
//

import UIKit
import CoreData

final class WatchListViewController: UIViewController {
    @IBOutlet private weak var watchlistTableView: UITableView!

    private var coins = [WatchlistCoin]()
    private var coinDataRepository = CoinDataRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }

    private func configViews() {
        navigationController?.navigationBar.isHidden = true
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "cell")
        coins = coinDataRepository.getAll(completion: { error in
            self.showAlert(title: "Error", message: error.localizedDescription)
        })
        updateUI()
    }
    private func fetchDataCoreData () {
        coins = coinDataRepository.getAll(completion: { error in
            self.showAlert(title: "Error", message: error.localizedDescription)
        })
    }
    private func updateUI() {
        fetchDataCoreData()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.watchlistTableView.reloadData()
        }
    }

    @IBAction private func openSearchScreen(_ sender: UIButton) {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension WatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }
        cell.setDataCell(coin: coins[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            coinDataRepository.removeCoin(myListObject: coins[indexPath.row]) { error in
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            coins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        watchlistTableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.setUuid(uuid: coins[indexPath.row].uuid)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
}
