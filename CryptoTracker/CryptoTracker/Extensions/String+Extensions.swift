//
//  String+Extensions.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/24/22.
//

import Foundation

extension String {
    func convertToNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if self.contains(".") {
            let doubleNumber =  Double(self) ?? 0.0
            guard let formattedNumber = numberFormatter.string(from: NSNumber(value: doubleNumber)) else {
                return "N/A"
            }
            return formattedNumber
        }
        let intNumber = Int(self) ?? 0
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: intNumber)) else {
            return "N/A"
        }
        return formattedNumber
    }

    var isNumeric: Bool {
        return Double(self) != nil
    }

    var doubleNumber: Double {
        return Double(self) ?? 1.0
    }
}
