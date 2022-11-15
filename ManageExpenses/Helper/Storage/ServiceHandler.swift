//
//  TransactionServiceHandler.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import Combine

enum TransactionDuration: String {
    case thisDay = "0"
    case thisMonth = "2"
    case thisWeek = "1"
    case thisYear = "3"
    case customRange = "4"
}

protocol ServiceHandlerType {
    func getBanksList() -> AnyPublisher<[SelectDataModel], NetworkingError>
    func saveBank(bank: SelectDataModel) -> AnyPublisher<Void, NetworkingError>
    func updateBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError>
    func deleteBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError>
    func fetchBudgetList() -> AnyPublisher<[BudgetDetail], NetworkingError>
    func deleteTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError>
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError>
    func addTransfer(transaction: Transaction) -> AnyPublisher<Void, NetworkingError>
    func getTransactions(duration: String,
                         sortBy: SortedBy,
                         filterBy: PlusMenuAction,
                         selectedCat: [String],
                         fromDate: Date,
                         toDate: Date,
                         completion: @escaping (NetworkingError?, [Transaction]?) -> Void)
}


