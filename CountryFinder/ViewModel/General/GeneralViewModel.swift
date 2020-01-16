//
//  GeneralViewModel.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/17/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import Foundation

protocol GeneralViewModelType: class {
    var manager: CoreDataManagerType { get }
}

class GeneralViewModel: GeneralViewModelType {
    let manager: CoreDataManagerType
    
    init() {
        manager = CoreDataManager()
    }
}
