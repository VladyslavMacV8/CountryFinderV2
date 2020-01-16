//
//  Constants.swift
//  CountryFinder
//
//  Created by Vladyslav on 3/11/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import RxSwift

enum Constants {
    static let baseURL = "https://restcountries.eu/rest/v2"
}

struct Queues {
    static let workQueue = DispatchQueue(label: "com.countryFinder.workQueue", attributes: .concurrent)
    static let backgroundQueue = ConcurrentDispatchQueueScheduler(qos: .background)
}
