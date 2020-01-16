//
//  CountryCollectionViewCell.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit

final class CountryCollectionViewCell: UICollectionViewCell, Reusable, NibLoadable {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        iconImageView.layer.cornerRadius = 5
    }
    
    func setupCell(_ value: CountryEntity) {
        iconImageView.loadImageAsync(with: "http://www.geognos.com/api/en/countries/flag/\(value.alphaCode).png", and: "Flag_placeholder")
        titleLabel.text = value.name
    }
}
