//
//  BudgetModel.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import Foundation


struct BudgetModel {
    var month: String
    var budget: [BudgetDetail]
}

struct BudgetDetail {
    var category: SelectDataModel
    var limit: Double
}
