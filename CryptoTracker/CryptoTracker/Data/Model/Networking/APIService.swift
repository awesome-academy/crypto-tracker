//
//  APIService.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/11/22.
//

import Foundation

class APIService {
    static let shared = APIService()

    private init () {}

    private var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Key", ofType: "plist") else {
          fatalError("Can't find file 'Key.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "apiKey") as? String else {
          fatalError("Can't find key in 'Key.plist'.")
        }
        return value
      }
    }

    func requestData<T: Codable>(urlString: String, method: String, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let url = URL(string: urlString)
        guard let urlPath = url else {
            return
        }
        var request = URLRequest(url: urlPath)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                completion(.failure(RequestError.wrongData))
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                print(result)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        task.resume()
    }
}
