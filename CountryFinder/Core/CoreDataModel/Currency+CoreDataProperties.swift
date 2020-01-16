//
//  Currency+CoreDataProperties.swift
//  CountryFinder
//
//  Created by Vladyslav on 3/11/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//
//

import Foundation
import CoreData

extension Currency {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged var name: String?
    @NSManaged var country: Country
}
