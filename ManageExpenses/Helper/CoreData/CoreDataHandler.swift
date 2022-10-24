//
//  CoreDataHandler.swift
//  ManageExpenses
//
//  Created by Ali Murad on 24/10/2022.
//

import CoreData
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Transactions")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
