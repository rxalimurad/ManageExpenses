//
//  DataSets.swift
//  ManageExpenses
//
//  Created by Ali Murad on 24/10/2022.
//

import Foundation
import CoreData
class DataSets {
    
}


extension Category {
    convenience init(id: String, desc: String, entity: NSEntityDescription, context: NSManagedObjectContext!) {
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.desc = desc
    }
}
