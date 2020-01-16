//
//  CountryEntity.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import Foundation

struct CountryEntity: Codable {
    let name: String
    let nativeName: String
    let alphaCode: String
    let region: String
    let coordinates: [Double]
    let borders: [String]
    let currencies: [CurrencyCountryEntity]
    let languages: [LanguageCountryEntity]
    
    enum CodingKeys: String, CodingKey {
        case name, nativeName, borders, languages, currencies, region
        case alphaCode = "alpha2Code"
        case coordinates = "latlng"
    }
}

struct CurrencyCountryEntity: Codable {
    let name: String?
}

struct LanguageCountryEntity: Codable {
    let name: String?
}
