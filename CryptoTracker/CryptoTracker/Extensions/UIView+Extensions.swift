//
//  UIView+Extensions.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/25/22.
//

import UIKit

extension UIView {
    func setBorderAndShadow(borderWidth: CGFloat = 1,
                            borderColor: CGColor = UIColor.black.cgColor ) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }

    func setRoundCorner(cornerRadius: CGFloat = 10.0,
                        shadowColor: CGColor = UIColor.black.cgColor,
                        shadowOpacity: Float = 0.2,
                        shadowOffset: CGSize = CGSize(width: 4, height: 4),
                        shadowRadius: CGFloat = 5.0,
                        isMaskToBound: Bool = false) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = isMaskToBound
    }
}

extension UIButton {
    func setContentInSet(top: CGFloat = 10.0,
                         left: CGFloat = 10.0,
                         bottom: CGFloat = 10.0,
                         right: CGFloat = 10.0) {
        self.contentEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
