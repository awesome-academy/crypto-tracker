//
//  PortfolioViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import UIKit
import CoreData

final class PortfolioViewController: UIViewController {
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var investmentLabel: UILabel!
    @IBOutlet private weak var addCoinView: UIView!
    @IBOutlet private weak var portfolioTableView: UITableView!
    @IBOutlet private weak var searchCoinButton: UIButton!
    @IBOutlet private weak var coinTextField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var labelInvestment: UILabel!
    @IBOutlet private weak var labelBalance: UILabel!

    private var investmentValue = 0.0
    private var balanceValue = 1.0
    private var listPortfolioCoins = [PortfolioCoin]()
    private var coin: BaseCoin?
    private var apiRepository = APIRepository()
    private var coreDataRepository = CoinDataRepository()
    private var listDetailCoin = [DetailCoin]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        portfolioTableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "cell")
        updateUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyBoard() {
        view.endEditing(true)
    }

    private func updateUI() {
        let group = DispatchGroup()

        self.coreDataRepository.getAllPorfolioCoin { [unowned self] error, coinlist in
            guard error == nil, let coinlist = coinlist else {
                let messageError = error?.localizedDescription ?? Constants.undetectedError.rawValue
                self.showAlert(title: "Error", message: messageError )
                return
            }
            listPortfolioCoins = coinlist
            balanceValue = 0
            listDetailCoin = [DetailCoin]()
            for coinIndex in listPortfolioCoins {
                group.enter()
                apiRepository.getDetailCoin(uuid: coinIndex.uuid,
                                            method: .get) { coin, error in
                    guard error == nil, let coin = coin else {
                        let errorMessage = error?.localizedDescription ?? Constants.undetectedError.rawValue
                        self.showAlert(title: "Alert", message: errorMessage)
                        return
                    }
                    let amount = Double(coinIndex.amount) ?? 1.0
                    let price = Double(coin.price ?? "1.0") ?? 1.0
                    self.balanceValue += amount * price
                    self.listDetailCoin.append(coin)
                    group.leave()
                }
            }
        }
        group.enter()
        self.investmentValue = self.coreDataRepository.getTotalValueInvestment(completion: { [unowned self] error in
            self.showAlert(title: "Error", message: error.localizedDescription)
            group.leave()
            return
        })
        group.leave()
        group.notify(queue: .main) {
            self.portfolioTableView.reloadData()
            self.investmentLabel.text = String(self.investmentValue).convertToNumber()
            self.labelBalance.text = String(self.balanceValue).convertToNumber()
        }
    }

    @IBAction private func searchCoinButtonPressed(_ sender: UIButton) {
        let searchVC  =  SearchViewController()
        searchVC.completionUuid = { [weak self] result in
            guard  let self = self else {
                return
            }
            self.coin = result
            sender.setTitle("\(self.coin?.symbol ?? "N/A") ⌵", for: .normal)
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        saveCoinData()
    }

    private func saveCoinData() {
        guard let numberCoin = coinTextField.text else {
            self.showAlert(title: "Error", message: "Please input the amount of coin")
            return
        }
        guard let coin = coin, let priceCoin = coin.price, priceCoin.isNumeric, numberCoin.isNumeric else {
            self.showAlert(title: "Error", message: "Please input valid number")
            return
        }
        let isExisted = coreDataRepository.checkPortfolioCoinExist(uuid: coin.uuid,
                                                                   completion: { [unowned self] error in
             self.showAlert(title: "Error", message: error.localizedDescription)
             return
        })
        if isExisted {
            coreDataRepository.updateCoin(uuid: coin.uuid, amount: numberCoin, coin: coin) { [unowned self] error in
                self.showAlert(title: "Error", message: error.localizedDescription )
            }
            updateUI()
        } else {
            let portfolioCoin = coreDataRepository.createPortfolioCoinCoinDataObject(coin: coin, amount: numberCoin)
            let totalValue =  (Double(numberCoin) ?? 0.0 ) * (Double(priceCoin) ?? 0.0)
            portfolioCoin.price = String(totalValue).convertToNumber()
            coreDataRepository.addCoin(myListObject: portfolioCoin) { [unowned self] error in
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            updateUI()
        }
    }
}

extension PortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPortfolioCoins.count
    }
}

extension PortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?  CoinCell else {
            return UITableViewCell()
        }
        cell.setDataCell(coin: listPortfolioCoins[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            coreDataRepository.removeCoin(myListObject: listPortfolioCoins[indexPath.row]) { error in
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            listPortfolioCoins.remove(at: indexPath.row)
            listDetailCoin.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateUI()
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.setUuid(uuid: listPortfolioCoins[indexPath.row].uuid)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
