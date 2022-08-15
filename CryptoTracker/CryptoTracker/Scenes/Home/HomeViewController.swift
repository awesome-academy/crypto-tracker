//
//  HomeViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var rankButton: UIButton!
    @IBOutlet private weak var coinTableView: UITableView!
    @IBOutlet private weak var rankStackView: UIStackView!
    @IBOutlet var rankOptions: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
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
        self.coinTableView.reloadData()
    }

    @IBAction private func openRankingOptions(_ sender: UIButton) {
        rankStackView.isHidden = false
    }

    @IBAction private func openSearchController(_ sender: UIButton) {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = coinTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }
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
        return 2
    }
}
