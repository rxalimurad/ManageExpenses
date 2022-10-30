//
//  BudgetViewModel.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import Foundation

class BudgetViewModel: ObservableObject {
    var monthlyBudgetList = [BudgetModel]()
    
    init() {
        monthlyBudgetList.append(BudgetModel(month: "May", budget: [BudgetDetail(category: SelectDataModel(id: "1", desc: "Shopping", Image: nil, color: CustomColor.yellow, isSelected: false), limit: 1500)
                                                                   ,BudgetDetail(category: SelectDataModel(id: "1", desc: "Transportation  ", Image: nil, color: CustomColor.blue, isSelected: false), limit: 500)]))
        
       
        
        monthlyBudgetList.append(BudgetModel(month: "June", budget: [BudgetDetail(category: SelectDataModel(id: "1", desc: "Transportation  ", Image: nil, color: CustomColor.blue, isSelected: false), limit: 6868)]))
        monthlyBudgetList.append(BudgetModel(month: "June", budget: [BudgetDetail(category: SelectDataModel(id: "1", desc: "Shopping", Image: nil, color: CustomColor.blue, isSelected: false), limit: 6564)]))
        
    }
    
}