//
//  CountriesTableViewCell.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit

final class CountriesTableViewCell: UITableViewCell, Reusable, NibLoadable {

    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nativeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setupCell(_ value: CountryEntity) {
        flagImageView.loadImageAsync(with: "http://www.geognos.com/api/en/countries/flag/\(value.alphaCode).png", and: "Flag_placeholder")
        nameLabel.text = value.name
        nativeNameLabel.text = value.nativeName
    }
}
