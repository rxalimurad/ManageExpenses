//
//  BudgetCellVM.swift
//  ManageExpenses
//
//  Created by murad on 15/11/2022.
//

import Foundation
import Combine

class BudgetCellVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    var budget: BudgetDetail
    
    @Published var spending: Double = 0
    @Published  var percentage: Double = 100
    @Published var isLimitExceed: Bool = false
    init(budget: BudgetDetail) {
        self.budget = budget
        DataCache.shared.$catSpendingDict
            .sink { cate in
                self.spending = cate[budget.category.desc.lowercased()] ?? 0
                self.percentage = self.getPercentage()
                self.isLimitExceed = self.checkLimit()
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
