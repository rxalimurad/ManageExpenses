//
//  HomeViewModel.swift
//  ManageExpenses
//
//  Created by murad on 18/10/2022.
//

import Foundation
import Combine
import SwiftUI


protocol HomeViewModelType {
    var currentFilter: TransactionDuration { get }
    var transactions: [DatedTransactions] { get }
    var dbHandler: ServiceHandlerType { get }
    init(dbHandler: ServiceHandlerType)
    func getAccountBalance() -> String
    func getIncome() -> String
    func getExpense() -> String
    
}

class HomeViewModel: ObservableObject, HomeViewModelType {
    var subscriptions =  Set<AnyCancellable>()

    @Published var currentFilter: TransactionDuration = .thisMonth
    @Published var transactions: [DatedTransactions] = []
    
    var dbHandler: ServiceHandlerType
    
    required init(dbHandler: ServiceHandlerType) {
        self.dbHandler = dbHandler
        self.observeDuration()
//        let queue = DispatchQueue(label: "com.swiftpal.dispatch.qos")
        DispatchQueue.main.async(qos: .userInitiated) {[weak self] in
            guard let self = self else { return }
            self.transactions = self.dbHandler.getTransactions(for: self.currentFilter)
        }
        
    }
    
    func getAccountBalance() -> String {
        return dbHandler.getTotalBalance()
    }
    func getIncome() -> String {
        return dbHandler.getIncome()
    }
    func getExpense() -> String {
        return dbHandler.getExpense()
    }
    func observeDuration() {
        $currentFilter.sink {[weak self] duration in
            guard let self = self else { return }
            self.transactions = self.dbHandler.getTransactions(for: duration)
        }.store(in: &subscriptions)
    }
    
}
