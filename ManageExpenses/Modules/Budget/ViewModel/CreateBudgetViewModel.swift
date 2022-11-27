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
    var state: ServiceAPIState { get }
    var service: ServiceHandlerType { get }
    init(service: ServiceHandlerType, excluded: [String], budget: BudgetDetail?)
    func updateBudget(completion: @escaping(( )-> Void))
    
}

class CreateBudgetViewModel: ObservableObject, CreateBudgetViewModelType {
    @Published var budget: BudgetDetail = BudgetDetail.getEmptyBudget()
    @Published var state: ServiceAPIState  = .na
    @Published var showAmtKeybd = false
    @Published var isCategoryshown = false
    @Published var categoryData = Utilities.getCategories()
    
    
    var subscription  = Set<AnyCancellable>()
    var service: ServiceHandlerType
    
    required init(service: ServiceHandlerType, excluded: [String], budget: BudgetDetail?) {
        self.service = service
        self.categoryData = self.categoryData.filter({ !excluded.contains($0.desc)})
        if let budget = budget {
            self.budget = budget
        }
    }
    
    func updateBudget(completion: @escaping (() -> Void)) {
        state = .inprogress
        service.updateBudget(budget: budget)
            .sink(receiveCompletion: { error in
                self.state = .failed(error: NetworkingError("An error has occured, please try again"))
                print (error)
            }, receiveValue: { _ in
                self.state = .successful
                completion()
            })
            .store(in: &subscription)
    }
    
    
}
