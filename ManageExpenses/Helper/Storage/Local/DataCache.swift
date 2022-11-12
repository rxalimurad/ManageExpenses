//
//  DataCache.swift
//  ManageExpenses
//
//  Created by murad on 11/11/2022.
//

import Foundation

class DataCache{
    private init() {}
    static let shared = DataCache()
    var banks = [SelectDataModel]()
    
   
    
    func clear() {
        banks = [SelectDataModel]()
    }
    
    
    
}
