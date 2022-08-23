//
//  DetailViewController.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/15/22.
//

import UIKit

final class DetailViewController: UIViewController {
    var uuid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }
    private func configViews() {
        title = "Detail"
    }
}
