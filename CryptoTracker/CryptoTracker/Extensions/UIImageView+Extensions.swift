//
//  UIImageView+Extensions.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/16/22.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        ImageManager.shared.fetchImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
