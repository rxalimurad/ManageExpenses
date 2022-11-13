//
//  BudgetDetailViewModel.swift
//  ManageExpenses
//
//  Created by murad on 13/11/2022.
//

import Foundation

import Combine
protocol BudgetDetailViewModelType {
    var service: ServiceHandlerType { get }
    init(service: ServiceHandlerType)
    func deleteBudget(budget: BudgetDetail, completion: @escaping(() -> Void))
}



class BudgetDetailViewModel: BudgetDetailViewModelType, ObservableObject {
    var subscription = Set<AnyCancellable>()
    var service: ServiceHandlerType
    
    required init(service: ServiceHandlerType) {
        self.service = service
    }
    

    
    
    func deleteBudget(budget: BudgetDetail, completion: @escaping(() -> Void)) {
        service.deleteBudget(budget: budget)
            .sink { error in
                print(error)
            } receiveValue: { _ in
                completion()
            }
            .store(in: &subscription)
    }
    
}
