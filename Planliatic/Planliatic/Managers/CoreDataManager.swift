//
//  CoreDataManager.swift
//  Planliatic
//
//  Created by Ali Erdem Kökcik on 27.09.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "PlanliaticModel")
        persistentContainer.loadPersistentStores{description, error in
            if let error = error {
                fatalError("Unable to initialize core data \(error)")
            }
        }
    }
}
