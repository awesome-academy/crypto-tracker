//
//  TabbarViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import UIKit

final class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
    }
    
    private func configTabbar() {
        view.backgroundColor = .white
        self.viewControllers = [
            configSubNavigationController(viewController: HomeViewController(), item: TabbarItem.home.item),
            configSubNavigationController(viewController: CalculatorViewController(), item: TabbarItem.caculator.item),
            configSubNavigationController(viewController: WatchListViewController(), item: TabbarItem.watchlist.item),
            configSubNavigationController(viewController: PortfolioViewController(), item: TabbarItem.portfolio.item)
        ]
    }

    private func configSubNavigationController(viewController: UIViewController, item: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = item
        return navigationController
    }
}
