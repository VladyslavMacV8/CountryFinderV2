//
//  MainViewModel.swift
//  CountryFinder
//
//  Created by Vladyslav on 3/11/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import RxSwift

protocol RegionsViewModelType: class {
    var regionsSubject: BehaviorSubject<[String]> { get }
    var bag: DisposeBag { get }
}

final class RegionsViewModel: GeneralViewModel, RegionsViewModelType {
    let regionsSubject = BehaviorSubject<[String]>(value: ["Africa", "Americas", "Asia", "Europe", "Oceania"])
    let bag = DisposeBag()

    override init() {
        super.init()
    }
}
