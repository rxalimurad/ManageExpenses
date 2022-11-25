//
//  BudgetViewModel.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import Foundation
import Combine

protocol UpdateBudget: AnyObject {
    func refreshView()
}


protocol BudgetViewModelType {
    var budgetList: [BudgetDetail] { get }
    var service: ServiceHandlerType { get }
    init(service: ServiceHandlerType)
}



class BudgetViewModel: BudgetViewModelType, UpdateBudget, ObservableObject {
    func refreshView() {
        fetchBudgetList()
    }
    
    @Published var budgetList: [BudgetDetail] = []
    var subscription = Set<AnyCancellable>()
    var service: ServiceHandlerType
    
    required init(service: ServiceHandlerType) {
        self.service = service
        fetchBudgetList()
    }
    
    
    func fetchBudgetList() {
        DataCache.shared.$budget
            .sink(receiveValue: { budgetList in
                self.budgetList = budgetList
            })
            .store(in: &subscription)
    }
    
}
