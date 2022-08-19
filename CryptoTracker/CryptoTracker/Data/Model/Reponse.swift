//
//  Reponse.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/16/22.
//

import Foundation

struct Response<T: Codable>: Codable {
    let status: String
    let data: T
}
