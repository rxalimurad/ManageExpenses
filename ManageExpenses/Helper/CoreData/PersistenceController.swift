//
//  CoreDataHandler.swift
//  ManageExpenses
//
//  Created by Ali Murad on 24/10/2022.
//

import CoreData


struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init() {
        container = NSPersistentCloudKitContainer(name: "Transactions")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

