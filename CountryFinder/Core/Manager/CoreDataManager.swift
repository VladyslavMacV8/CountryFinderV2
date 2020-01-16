//
//  CoreDataManager.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataManagerType: class {
    func saveObject(_ value: CountryEntity)
    func fetchObjects(with completion: ([Country])->())
    func deleteObject(for nativeName: String)
    func isObjectExists(for nativeName: String) -> Bool
}

class CoreDataManager: CoreDataManagerType {
    var context: NSManagedObjectContext?
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }
    
    func saveObject(_ value: CountryEntity) {
        guard let ctx = context, let countryEntity = NSEntityDescription.entity(forEntityName: "Country", in: ctx),
            let languageEntity = NSEntityDescription.entity(forEntityName: "Language", in: ctx),
            let currencyEntity = NSEntityDescription.entity(forEntityName: "Currency", in: ctx) else { return }
        
        let newObject = Country(entity: countryEntity, insertInto: ctx)
        newObject.name = value.name
        newObject.nativeName = value.nativeName
        newObject.alphaCode = value.alphaCode
        newObject.region = value.region
        newObject.borders = value.borders
        newObject.coordinates = value.coordinates
        
        value.languages.forEach { entity in
            let obj = Language(entity: languageEntity, insertInto: ctx)
            obj.name = entity.name
            newObject.languages.insert(obj)
        }
        
        value.currencies.forEach { entity in
            let obj = Currency(entity: currencyEntity, insertInto: ctx)
            obj.name = entity.name
            newObject.currencies.insert(obj)
        }
        
        do {
            try ctx.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchObjects(with completion: ([Country])->()) {
        guard let ctx = context else { return }
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            completion(try ctx.fetch(fetchRequest))
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteObject(for nativeName: String) {
        guard let ctx = context else { return }
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try ctx.fetch(fetchRequest)
            for object in objects where object.nativeName == nativeName {
                object.currencies.forEach { currency in
                    ctx.delete(currency)
                }
                object.languages.forEach { language in
                    ctx.delete(language)
                }
                
                ctx.delete(object)
            }
            try ctx.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func isObjectExists(for nativeName: String) -> Bool {
        guard let ctx = context else { return false }
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nativeName = %@", nativeName)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try ctx.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return results.count <= 0
    }
}


