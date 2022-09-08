//
//  DetailViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/15/22.
//

import UIKit
import Charts
import CoreData

final class DetailViewController: UIViewController {

    @IBOutlet private var simpleViews: [UIView]!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var changeLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var sympolLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    @IBOutlet private weak var lineChartView: LineChartView!
    @IBOutlet private weak var segment: UISegmentedControl!
    @IBOutlet private weak var marketCap: UILabel!
    @IBOutlet private weak var volumeTrading: UILabel!
    @IBOutlet private weak var circulating: UILabel!
    @IBOutlet private weak var bitcoinPrice: UILabel!
    @IBOutlet private weak var allTimeHigh: UILabel!
    @IBOutlet private weak var totalSupply: UILabel!

    var isFavorite = false
    private var coinDataRepository = CoinDataRepository()
    var historyPrices = [History]()
    var detailCoin: DetailCoin?
    private var uuid = "Qwsogvtv82FCd"
    private var apiRepository = APIRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadDetailCoinFromAPI(uuid: uuid, message: .undetectedError)
        setImageFavouriteButton()
    }

    private func configViews() {
        configureChart()
        rankLabel.layer.cornerRadius = 10
        for simpleView in simpleViews {
            simpleView.setBorderAndShadow()
            simpleView.setRoundCorner()
        }
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        guard let coin = detailCoin else {
            return
        }
        if !isFavorite {
            let watchlistCoin = coinDataRepository.createCoinDataObject(coin: coin)
            coinDataRepository.addCoin(myListObject: watchlistCoin) { [unowned self] error in
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            setImageFavouriteButton()
        } else {
            let listCoin = coinDataRepository.getAll { [unowned self] error in
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            let deletedCoin =  listCoin.filter {$0.uuid == uuid}
            coinDataRepository.removeCoin(myListObject: deletedCoin[0]) { [unowned self] error in
                self.showAlert(title: "Erorr", message: error.localizedDescription)
            }
            setImageFavouriteButton()
        }
    }

    private func setImageFavouriteButton() {
        isFavorite = coinDataRepository.checkCoinExist(uuid: uuid, completion: { [unowned self] error in
            self.showAlert(title: "Erorr", message: error.localizedDescription)
        })

        favouriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" :  "heart"), for: .normal)
    }

    @IBAction func timeSegmentPressed(_ sender: Any) {
        var time = ""
        switch segment.selectedSegmentIndex {
        case 0:
            time = TimeSegment.oneHour.rawValue
        case 1:
            time = TimeSegment.threeHours.rawValue
        case 2:
            time = TimeSegment.oneDay.rawValue
        case 3:
            time = TimeSegment.oneMonth.rawValue
        case 4:
            time = TimeSegment.threeMonths.rawValue
        default:
            time = ""
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        apiRepository.getHistoryStats(uuid: uuid, time: time, method: .get) { [weak self] history, error in
            guard error == nil, let history = history else {
                self?.showAlert(title: "Alert",
                               message: error?.localizedDescription ?? Constants.undetectedError.rawValue)
                return
            }
            self?.historyPrices = history
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.loadDataChartDetailViewController()
        }
    }

    private func loadDetailCoinFromAPI(uuid: String, message: Constants) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        apiRepository.getDetailCoin(uuid: uuid,
                                    method: .get) { [weak self] coin, error in
            guard error == nil, let coin = coin else {
                let errorMessage = error?.localizedDescription ?? message.rawValue
                self?.showAlert(title: "Alert", message: errorMessage)
                dispatchGroup.leave()
                return
            }
            self?.detailCoin = coin
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        apiRepository.getHistoryStats(uuid: uuid,
                                      time: TimeSegment.oneHour.rawValue,
                                      method: .get) { [weak self] history, error  in
            guard error == nil, let history = history else {
                let errorMessage = error?.localizedDescription ?? message.rawValue
                self?.showAlert(title: "Alert", message: errorMessage)
                dispatchGroup.leave()
                return
            }
            self?.historyPrices = history
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.setDataDetailViewController()
            self?.loadDataChartDetailViewController()
        }
    }

    func loadDataChartDetailViewController() {
        let chartEntry = historyPrices.enumerated().map { index, historyPrices -> ChartDataEntry in
            guard let price = Double((historyPrices.price ?? detailCoin?.price) ?? "N/A") else {
                return ChartDataEntry(x: Double(index), y: 0)
            }
            return ChartDataEntry(x: Double(index), y: price)
        }
        let set = LineChartDataSet(entries: chartEntry, label: "Line chart")
        set.drawCirclesEnabled = false
        set.mode = .linear
        set.lineWidth = 1
        if chartEntry.first?.y ?? 10 < chartEntry.last?.y ?? 10 {
            set.setColor(.green)
        } else {
            set.setColor(.red)
        }
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 2)
    }

    private func configureChart() {
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.axisLineColor = .white
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.animate(xAxisDuration: 2)
    }

    func setDataDetailViewController() {
        guard let coin = detailCoin else {
            return
        }
        self.marketCap.text = "$\(coin.marketCap.convertToNumber())"
        self.volumeTrading.text = "$\(coin.volumePerDay.convertToNumber())"
        self.totalSupply.text = coin.supply.total?.convertToNumber() ?? "N/A"
        self.circulating.text = coin.supply.circulating.convertToNumber()
        self.priceLabel.text = "$\(coin.price?.convertToNumber() ?? "N/A")"
        self.rankLabel.text = "#\(coin.rank)"
        self.changeLabel.setPriceChangeNumber(priceChangeString: coin.change ?? "N/A")
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            self.iconImage.setImage(from: url)
        }
        self.sympolLabel.text = coin.symbol
        self.allTimeHigh.text = "$\(coin.allTimeHigh.price?.convertToNumber() ?? "N/A")"
        self.bitcoinPrice.text = coin.btcPrice.convertToNumber()
    }

    func setUuid (uuid: String) {
        self.uuid = uuid
    }
}
