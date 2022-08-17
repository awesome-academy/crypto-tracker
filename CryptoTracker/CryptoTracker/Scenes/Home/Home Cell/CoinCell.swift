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

    override func prepareForReuse() {
        super.prepareForReuse()
        coinImage.image = nil
    }

    func setDataInCellBy(coin: Coin) {
        coinName.text = coin.name
        coinSympol.text = coin.symbol
        priceLabel.setPriceNumber(priceString: coin.price)
        priceChangeLabel.setPriceChangeNumber(priceChangeString: coin.change)
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            coinImage.setImage(from: url)
        }
    }
}
