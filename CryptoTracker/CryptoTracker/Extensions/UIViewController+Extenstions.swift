//
//  UIViewController+Extenstions.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/18/22.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
