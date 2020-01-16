//
//  CountryView.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import MapKit

final class CountryView: UIView, NibLoadable {
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    
    func configData(_ value: CountryEntity?) {
        guard let value = value else { return }
        
        flagImageView.loadImageAsync(with: "http://www.geognos.com/api/en/countries/flag/\(value.alphaCode).png", and: "Flag_placeholder")
        
        
        let strings = value.currencies.map { String($0.name ?? "") }
        currencyLabel.text = strings.joined(separator: ", ")
        
        let languages = value.languages.map { String($0.name ?? "") }
        languageLabel.text = languages.joined(separator: ", ")
        
        centerMapOnLocation(value.coordinates)
    }
    
    private func centerMapOnLocation(_ coordinates: [Double]) {
        guard !coordinates.isEmpty else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
}
