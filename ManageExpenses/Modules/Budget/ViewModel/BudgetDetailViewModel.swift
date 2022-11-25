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
    init(service: ServiceHandlerType, budget: BudgetDetail)
    func deleteBudget(budget: BudgetDetail, completion: @escaping(() -> Void))
}



class BudgetDetailViewModel: BudgetDetailViewModelType, ObservableObject {
    var subscription = Set<AnyCancellable>()
    var service: ServiceHandlerType
    var budget: BudgetDetail
    @Published var spending: Double = 0
    @Published  var percentage: Double = 100
    @Published var isLimitExceed: Bool = false
    
    required init(service: ServiceHandlerType, budget: BudgetDetail) {
        self.service = service
        self.budget = budget
        DataCache.shared.$catSpendingDict
            .sink { cate in
                self.spending = cate[budget.category.desc.lowercased()] ?? 0
                self.percentage = self.getPercentage()
                self.isLimitExceed = self.checkLimit()
            }
            .store(in: &subscription)
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
    
    private func getPercentage() -> Double {
        if spending >= Double(budget.limit) ?? 0 {
            return 100
        }
        return (spending / (Double(budget.limit) ?? 0.0)) * 100
    }
    private func checkLimit() -> Bool {
        spending > Double(budget.limit) ?? 0.0
    }
}
