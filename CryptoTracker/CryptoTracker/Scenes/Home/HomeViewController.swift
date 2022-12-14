//
//  HomeViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet weak var rankedByChangeButton: UIButton!
    @IBOutlet weak var rankedBy2VolumePerDayButton: UIButton!
    @IBOutlet weak var rankedByMarketCapButton: UIButton!
    @IBOutlet weak var rankedByPriceButton: UIButton!
    @IBOutlet private weak var rankButton: UIButton!
    @IBOutlet weak var coinTableView: UITableView!
    @IBOutlet private weak var rankStackView: UIStackView!

    private var limit = 20
    private var urlResquest = Network.shared.getCoinsURL(rank: .marketCap)
    private var listTopCoin = [Coin]()
    private var apiRepository =  APIRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if listTopCoin.isEmpty {
            fetchDataFromAPI(url: urlResquest + "\(limit)", message: .undetectedError)
            return
        }
        fetchDataFromAPI(url: urlResquest + "\(listTopCoin.count)", message: .undetectedError)
    }

    private func configViews() {
        coinTableView.delegate = self
        coinTableView.dataSource = self
        rankStackView.isHidden = true
        coinTableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func rankButtonPressed(_ sender: UIButton) {
        rankStackView.isHidden = true
        switch sender {
        case rankedByPriceButton:
            urlResquest = Network.shared.getCoinsURL(rank: .price)
        case rankedByChangeButton:
            urlResquest = Network.shared.getCoinsURL(rank: .change)
        case rankedByMarketCapButton:
            urlResquest = Network.shared.getCoinsURL(rank: .marketCap)
        case rankedBy2VolumePerDayButton:
            urlResquest = Network.shared.getCoinsURL(rank: .volume)
        default:
            return
        }
        fetchDataFromAPI(url: urlResquest + "\(limit)", message: .undetectedError)
    }

    @IBAction func openRankingOptions(_ sender: UIButton) {
        rankStackView.isHidden = false
    }

    @IBAction func openSearchController(_ sender: UIButton) {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

    private func fetchDataFromAPI (url: String, message: Constants) {
        apiRepository.getListCoin(url: url, method: .get) { [weak self] coins, error in
            guard let self = self else {return}
            guard error == nil, let coins = coins else {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? message.rawValue)
                return
            }
            self.listTopCoin = coins
            DispatchQueue.main.async {
                self.coinTableView.reloadData()
            }
        }
    }

    func fetchMoreDataFromAPI (url: String, message: Constants) {
        apiRepository.getListCoin(url: url, method: .get) { [unowned self] coins, error in
            guard error == nil, let coins = coins else {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? message.rawValue)
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
        cell.setDataCell(coin: listTopCoin[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 80
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coinTableView.deselectRow(at: indexPath, animated: false)
        let detailVC = DetailViewController()
        detailVC.setUuid(uuid: "Qwsogvtv82FCd")
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTopCoin.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if listTopCoin.count - 1 == indexPath.row {
            fetchMoreDataFromAPI(url: urlResquest + "\(limit)" + "&offset=\(listTopCoin.count)", message: .undetectedError)
        }
    }
}
