//
//  Persistence.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/04.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // MARK: - Init
    private init() {
        self.container = NSPersistentContainer(name: "Hyoza")
        self.container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: Save Context
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
