//
//  MainTableViewCell.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit

final class RegionsTableViewCell: UITableViewCell, Reusable, NibLoadable {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setupCell(_ value: String) {
        iconImageView.image = UIImage(named: value)?.darkenImage
        titleLabel.text = value
    }
}

private extension UIImage {
    var darkenImage: UIImage? {
        guard let inputImage = CIImage(image: self), let filter = CIFilter(name: "CIExposureAdjust") else { return nil }
        filter.setValue(inputImage, forKey: "inputImage")
        filter.setValue(-3.0, forKey: "inputEV")
        
        guard let filteredImage = filter.outputImage else { return nil }
        let context = CIContext(options: nil)
        
        guard let imageContext = context.createCGImage(filteredImage, from: filteredImage.extent) else { return nil }
        
        return UIImage(cgImage: imageContext)
    }
}
