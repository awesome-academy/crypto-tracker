//
//  TabbarItems.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import Foundation
import UIKit

enum TabbarItem {
    case home
    case caculator
    case watchlist
    case portfolio

    var item: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        case .caculator:
            return UITabBarItem(title: "Calculator", image: UIImage(systemName: "dollarsign.circle"), tag: 1)
        case .watchlist:
            return UITabBarItem(title: "Watchlist", image: UIImage(systemName: "eye"), tag: 1)
        case .portfolio:
            return UITabBarItem(title: "Portfolio", image: UIImage(systemName: "text.badge.plus"), tag: 1)
        }
    }
}
