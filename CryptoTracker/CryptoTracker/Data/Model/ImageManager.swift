//
//  ImageManager.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/16/22.
//

import Foundation
import  UIKit

final class ImageManager {
    static let shared = ImageManager()
    private let imageCache = NSCache<NSString, UIImage>()

    private init() { }

    func fetchImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(.success(image))
        }
        task.resume()
    }
}
