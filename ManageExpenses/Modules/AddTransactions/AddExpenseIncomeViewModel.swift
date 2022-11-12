//
//  AddExpenseIncomeViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 25/10/2022.
//
import Foundation
import Combine
import SwiftUI

protocol AddExpenseIncomeViewModelType {
    var service: ServiceHandlerType { get }
    var serviceStatus: ServiceAPIState { get }
    init(service: ServiceHandlerType)
    func saveTransaction(transaction: Transaction)
    func deleteTransaction(id: String)
    
}


class AddExpenseIncomeViewModel: ObservableObject, AddExpenseIncomeViewModelType {
    var service: ServiceHandlerType
    var subscription = Set<AnyCancellable>()
    @Published var serviceStatus: ServiceAPIState = .na
    @Published var categoryData = [SelectDataModel]()
    @Published var fromWallet = DataCache.shared.banks
    @Published var toWallet = DataCache.shared.banks
    required init(service: ServiceHandlerType) {
        self.service = service
        categoryData = Utilities.getCategories()
    }
    
    func saveTransaction(transaction: Transaction) {
        service.addTransaction(transaction: transaction)
            .sink { error in
                print(error)
            } receiveValue: { _ in
                
            }.store(in: &subscription)
        
    }
    func transfer(transaction: Transaction) {
        service.addTransfer(transaction: transaction)
            .sink { error in
                print(error)
            } receiveValue: { _ in
                
            }.store(in: &subscription)
        
    }
    func deleteTransaction(id: String) {
        
    }
    
}
