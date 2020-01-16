//
//  MainService.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/12/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import RxSwift

protocol CountriesServiceType {
    func getRegionData(_ region: String) -> Observable<[CountryEntity]>
    func getSearchData(_ value: String) -> Observable<[CountryEntity]>
}

struct CountriesService: CountriesServiceType {
    func getRegionData(_ region: String) -> Observable<[CountryEntity]> {
        return NetworkProcessing.make(with: .byRegion(region.lowercased()))
    }
    
    func getSearchData(_ value: String) -> Observable<[CountryEntity]> {
        return NetworkProcessing.make(with: .byName(value))
    }
}
