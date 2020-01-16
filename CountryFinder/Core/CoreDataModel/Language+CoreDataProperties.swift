//
//  Language+CoreDataProperties.swift
//  CountryFinder
//
//  Created by Vladyslav on 3/11/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//
//

import Foundation
import CoreData

extension Language {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Language> {
        return NSFetchRequest<Language>(entityName: "Language")
    }

    @NSManaged var name: String?
    @NSManaged var country: Country
}
