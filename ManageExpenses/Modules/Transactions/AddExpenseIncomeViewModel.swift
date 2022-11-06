//
//  AddExpenseIncomeViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 25/10/2022.
//
import Foundation
import CoreData
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
    
    @Published var serviceStatus: ServiceAPIState = .na
    
    required init(service: ServiceHandlerType) {
        self.service = service
    }
    
    func saveTransaction(transaction: Transaction) {
        service.addTransaction(transaction: transaction)
    }
    
    func deleteTransaction(id: String) {
        
    }
    
    
    
    
}
