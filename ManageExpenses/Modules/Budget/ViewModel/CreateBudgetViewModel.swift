//
//  CreateBudgetViewModel.swift
//  ManageExpenses
//
//  Created by murad on 13/11/2022.
//

import Foundation
import Combine
protocol CreateBudgetViewModelType {
    var budget: BudgetDetail { get }
    var service: ServiceHandlerType { get }
    init(service: ServiceHandlerType)
    func updateBudget(completion: @escaping(( )-> Void))
    
}

class CreateBudgetViewModel: ObservableObject, CreateBudgetViewModelType {
    @Published var budget: BudgetDetail = .new
    
    @Published var showAmtKeybd = false
    @Published var isCategoryshown = false
    @Published var categoryData = Utilities.getCategories()
    
    
    var subscription  = Set<AnyCancellable>()
    var service: ServiceHandlerType
    
    required init(service: ServiceHandlerType) {
        self.service = service
    }
    
    func updateBudget(completion: @escaping (() -> Void)) {
        service.updateBudget(budget: budget)
            .sink(receiveCompletion: { error in
                print (error)
            }, receiveValue: { _ in
                completion()
            })
            .store(in: &subscription)
    }
    
    
}
