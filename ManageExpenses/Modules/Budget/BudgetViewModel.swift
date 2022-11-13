//
//  BudgetViewModel.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import Foundation

protocol BudgetViewModelType {
    var budgetList: [BudgetDetail] { get }
    var service: ServiceHandlerType { get }
    init(service: ServiceHandlerType)
    
}



class BudgetViewModel: BudgetViewModelType, ObservableObject {
    @Published var budgetList: [BudgetDetail] = []
    
    var service: ServiceHandlerType
    
    required init(service: ServiceHandlerType) {
        self.service = service
    }
    
    
//    init() {
//       
////        monthlyBudgetList = [BudgetDetail(category: SelectDataModel(id: "1", desc: "Shopping", Image: nil, color: CustomColor.yellow, isSelected: false), limit: 1500, month: "May")
////                             ,BudgetDetail(category: SelectDataModel(id: "1", desc: "Transportation  ", Image: nil, color: CustomColor.blue, isSelected: false), limit: 500, month: "May")]
//        
//    }
    
}
