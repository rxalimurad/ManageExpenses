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
        monthlyBudgetList.append(BudgetModel(month: "May", budget: [BudgetDetail(category: SelectDataModel(id: "1", desc: "Shopping", Image: nil, color: CustomColor.yellow, isSelected: false), limit: 20)
                                                                   ,BudgetDetail(category: SelectDataModel(id: "1", desc: "Transportation  ", Image: nil, color: CustomColor.blue, isSelected: false), limit: 200)]))
        
       
        
        monthlyBudgetList.append(BudgetModel(month: "June", budget: [BudgetDetail(category: SelectDataModel(id: "1", desc: "Transportation  ", Image: nil, color: CustomColor.blue, isSelected: false), limit: 200)]))
        monthlyBudgetList.append(BudgetModel(month: "June", budget: [BudgetDetail(category: SelectDataModel(id: "1", desc: "Shopping", Image: nil, color: CustomColor.blue, isSelected: false), limit: 200)]))
        
    }
    
}
