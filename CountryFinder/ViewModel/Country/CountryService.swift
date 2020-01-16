//
//  CountryService.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import RxSwift

protocol CountryServiceType {
    func getBorderData(_ codes: String) -> Observable<[CountryEntity]>
}

struct CountryService: CountryServiceType {
    func getBorderData(_ codes: String) -> Observable<[CountryEntity]> {
        return NetworkProcessing.make(with: .byCodes(codes))
    }
}
