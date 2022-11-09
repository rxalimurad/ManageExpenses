//
//  DBHandler.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import Combine

enum TransactionDuration: Int {
    case thisDay = 0
    case thisMonth = 2
    case thisWeek = 1
    case thisYear = 3
    case customRange = 4
}

protocol ServiceHandlerType {
    func getTotalBalance() -> String
    func getExpense() -> String
    func getIncome() -> String
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError>
    func getTransaction(with id: String) -> AnyPublisher<Transaction, NetworkingError>
    func getTransactions(for duration: TransactionDuration) -> AnyPublisher<[DatedTransactions], NetworkingError>
    func getTransactions(duration: TransactionDuration, sortBy: SortedBy, filterBy: PlusMenuAction) -> AnyPublisher<[Transaction], NetworkingError>
    func getTransactions(fromDate: Date, toDate: Date) -> AnyPublisher<[DatedTransactions], NetworkingError>
}


