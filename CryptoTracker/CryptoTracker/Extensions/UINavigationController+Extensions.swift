//
//  UINavigationController+Extensions.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/19/22.
//

import UIKit

extension UINavigationController {
    var previousViewController: UIViewController? {
       viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
}
