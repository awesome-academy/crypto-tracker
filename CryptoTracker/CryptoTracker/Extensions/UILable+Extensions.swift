//
//  UILable+Extensions.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/17/22.
//

import UIKit

extension UILabel {
    func setPriceChangeNumber(priceChangeString: String) {
        guard let changeNumber = Double(priceChangeString) else {
            self.text = ""
            return
        }
        (self.textColor, self.text) = (changeNumber > 0) ?
            (.green, "+\(String(format: "%.2f", changeNumber))%") : (.red, "\(String(format: "%.2f", changeNumber))%" )
    }

    func setPriceNumber(priceString: String) {
        guard let priceNumber = Double(priceString) else {
            self.text = ""
            return
        }
        self.text = "$" + String(format: "%.2f", priceNumber)
    }
}
