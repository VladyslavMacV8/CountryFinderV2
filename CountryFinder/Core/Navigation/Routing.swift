//
//  Routing.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/12/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import Foundation

enum Routing {
    
    case pop
    case dismiss
    
    case openCountriesViewController(String)
    case openCountryViewController(CountryEntity, CountriesControllerState)
}
