//
//  HomeViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private weak var rankedByChangeButton: UIButton!
    @IBOutlet private weak var rankedBy2VolumePerDayButton: UIButton!
    @IBOutlet weak private var rankedByMarketCapButton: UIButton!
    @IBOutlet private weak var rankedByPriceButton: UIButton!
    @IBOutlet private weak var rankButton: UIButton!
    @IBOutlet private weak var coinTableView: UITableView!
    @IBOutlet private weak var rankStackView: UIStackView!
    @IBOutlet var rankOptions: [UIButton]!

    private var urlResquest = Network.shared.getCoinsURL(path: RankingPath.topMarketCap)
    private var listTopCoin = [Coin]()
    private var apiRepository =  APIRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        fetchDataFromAPI(urlRequet: urlResquest)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    private func configViews() {
        coinTableView.delegate = self
        coinTableView.dataSource = self
        rankStackView.isHidden = true
        coinTableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction private func rankButtonPressed(_ sender: UIButton) {
        rankStackView.isHidden = true
        switch sender {
        case rankedByPriceButton:
            urlResquest = Network.shared.getCoinsURL(path: RankingPath.topPrice)
        case rankedByChangeButton:
            urlResquest = Network.shared.getCoinsURL(path: RankingPath.topChange)
        case rankedByMarketCapButton:
            urlResquest = Network.shared.getCoinsURL(path: RankingPath.topMarketCap)
        case rankedBy2VolumePerDayButton:
            urlResquest = Network.shared.getCoinsURL(path: RankingPath.top24Volume)
        default:
            return
        }
        fetchDataFromAPI(urlRequet: urlResquest)
    }

    @IBAction private func openRankingOptions(_ sender: UIButton) {
        rankStackView.isHidden = false
    }

    @IBAction private func openSearchController(_ sender: UIButton) {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

    private func fetchDataFromAPI (urlRequet: String) {
        apiRepository.getListCoin(url: urlResquest, method: HTTPMethod.get) { [unowned self] coins, error in
            guard let coins = coins, error == nil else {
                self.showAlert(title: "Alert", message: error?.localizedDescription ?? "Undetected Error")
                return
            }
            self.listTopCoin = coins
            DispatchQueue.main.async {
                self.coinTableView.reloadData()
            }
        }
    }

    private func fetchMoreDataFromAPI (url: String) {
        apiRepository.getListCoin(url: url, method: HTTPMethod.get) { [unowned self] coins, error in
            guard let coins = coins, error == nil else {
                self.showAlert(title: "Alert", message: error?.localizedDescription ?? "Undetected Error")
                return
            }
            self.listTopCoin.append(contentsOf: coins)
            DispatchQueue.main.async {
                self.coinTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = coinTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }
        cell.setDataInCellBy(coin: listTopCoin[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 80
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coinTableView.deselectRow(at: indexPath, animated: false)
        let detailVC = DetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTopCoin.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if listTopCoin.count - 1 == indexPath.row {
            fetchMoreDataFromAPI(url: urlResquest + "&offset=\(listTopCoin.count)")
        }
    }
}
