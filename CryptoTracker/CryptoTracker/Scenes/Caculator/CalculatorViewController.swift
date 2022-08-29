//
//  CalculatorViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import UIKit

final class CalculatorViewController: UIViewController {
    @IBOutlet private weak var targetView: UIView!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var targetTextfield: UITextField!
    @IBOutlet private weak var targetButton: UIButton!
    @IBOutlet private weak var baseCoinButton: UIButton!
    @IBOutlet private weak var exchangeButton: UIButton!

    private var baseCoin: BaseCoin?
    private var targetCoin: BaseCoin?
    private var apiRepository = APIRepository()
    private var exchangeRate = "1.0"
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }

    private func configViews() {
        exchangeButton.setRoundCorner()
        exchangeButton.setContentInSet()
        baseCoinButton.setRoundCorner()
        baseCoinButton.setContentInSet()
        baseCoinButton.setBorderAndShadow()
        targetButton.setRoundCorner()
        targetButton.setContentInSet()
        targetButton.setBorderAndShadow()
        targetView.setRoundCorner()
        targetView.setBorderAndShadow()
        baseView.setRoundCorner()
        baseView.setBorderAndShadow()
        navigationController?.navigationBar.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }

    @IBAction private func exchangeButton(_ sender: UIButton) {
        getExhangeRateFromAPI()
    }

    private func getExhangeRateFromAPI() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let baseUUID = baseCoin?.uuid ?? Constants.bnbUUID.rawValue
        let targetUUID = targetCoin?.uuid ?? Constants.usdtUUID.rawValue
        apiRepository.getEchangeRate(baseUUID: baseUUID,
                                     targetUUID: targetUUID,
                                     method: .get) { [unowned self] rate, error in
            guard error == nil, let rate = rate else {
                let message = error?.localizedDescription ?? Constants.undetectedError.rawValue
                self.showAlert(title: "Alert", message: message)
                return
            }
            self.exchangeRate = rate
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [unowned self] in
            guard let baseNumber = self.targetTextfield.text, baseNumber.isNumeric, self.exchangeRate.isNumeric else {
                self.showAlert(title: "Error", message: "Please input valid number")
                return
            }
            let result = (Double(self.exchangeRate) ?? 1.0 ) * (Double(baseNumber) ?? 1.0)
            self.resultLabel.text = String(result).convertToNumber()
        }
    }

    private func coinButtonPressed (button: UIButton) {
        let searchVC = SearchViewController()
        searchVC.completionUuid = { [weak self] result in
            guard let self = self else {
                return
            }
            switch button {
            case self.baseCoinButton:
                self.baseCoin = result
            case self.targetButton:
                self.targetCoin = result
            default:
                return
            }
            button.setTitle("\(result.symbol) ⌵", for: .normal)
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @IBAction private func baseCoinButtonPressed(_ sender: UIButton) {
        coinButtonPressed(button: sender)
    }

    @IBAction func targetButtonPressed(_ sender: UIButton) {
        coinButtonPressed(button: sender)
    }
}
