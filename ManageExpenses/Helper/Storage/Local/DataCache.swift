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
    @Published var banks = [SelectDataModel]()
    @Published var budget = [BudgetDetail]()
    
   
    
    func clear() {
        banks = [SelectDataModel]()
    }
    
    
    
}
