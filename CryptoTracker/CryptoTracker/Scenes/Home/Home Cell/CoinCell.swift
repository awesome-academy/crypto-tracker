//
//  CoinCell.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/15/22.
//

import UIKit

final class CoinCell: UITableViewCell {

    @IBOutlet private weak var coinImage: UIImageView!
    @IBOutlet private weak var coinName: UILabel!
    @IBOutlet private weak var coinSympol: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceChangeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
