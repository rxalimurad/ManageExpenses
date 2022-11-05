//
//  InitialConfigurations.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation

class InitialConfigurations {
    
    func copyDatabaseIfNeeded() {
            let fileManager = FileManager.default
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask)
            
            guard documentsUrl.count != 0 else {
                return // Could not find documents URL
            }
            let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("InitConfig.db")
            if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
                print("DB does not exist in documents folder")
                let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("InitConfig.db")
                do {
                      try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
                      } catch let error as NSError {
                        print("Couldn't copy file to final location! Error:\(error.description)")
                }
            } else {
                print("Database file found at path: \(finalDatabaseURL.path)")
            }
        
        }
    
}
