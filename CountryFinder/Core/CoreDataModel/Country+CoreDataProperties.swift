//
//  Country+CoreDataProperties.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//
//

import Foundation
import CoreData

extension Country {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged var borders: [String]
    @NSManaged var coordinates: [Double]
    @NSManaged var alphaCode: String
    @NSManaged var name: String
    @NSManaged var nativeName: String
    @NSManaged var region: String
    @NSManaged var currencies: Set<Currency>
    @NSManaged var languages: Set<Language>
}
