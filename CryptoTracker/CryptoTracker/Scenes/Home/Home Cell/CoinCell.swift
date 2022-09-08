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
    @IBOutlet private weak var amountCoinLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        amountCoinLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coinImage.image = nil
    }

    func setDataCell(coin: Coin) {
        coinName.text = coin.name
        coinSympol.text = coin.symbol
        priceLabel.setPriceNumber(priceString: coin.price)
        priceChangeLabel.setPriceChangeNumber(priceChangeString: coin.change)
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            coinImage.setImage(from: url)
        }
    }

    func setDataCell(coin: BaseCoin, error: Constants) {
        coinName.text = coin.name
        coinSympol.text = coin.symbol
        priceLabel.setPriceNumber(priceString: coin.price ?? error.rawValue)
        priceChangeLabel.isHidden = true
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            coinImage.setImage(from: url)
        }
    }

    func setDataCell(coin: WatchlistCoin) {
        coinName.text = coin.name
        coinSympol.text = coin.sympol
        priceLabel.setPriceNumber(priceString: coin.price ?? "N/A")
        priceChangeLabel.isHidden = true
        let pngUrl = coin.image.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            coinImage.setImage(from: url)
        }
    }

    func setDataCell(coin: PortfolioCoin) {
        coinName.text = coin.name
        coinSympol.text = "\(coin.amount) \(coin.symbol)"
        priceChangeLabel.isHidden = true
        priceLabel.isHidden = true
        let pngUrl = coin.image.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            coinImage.setImage(from: url)
        }
    }
}
