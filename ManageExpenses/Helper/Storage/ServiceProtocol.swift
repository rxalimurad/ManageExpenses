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
    case thisMonth = 1
    case thisWeek = 2
    case thisYear = 3
}

protocol ServiceHandlerType {
    func getTotalBalance() -> String
    func getExpense() -> String
    func getIncome() -> String
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError>
    func getTransaction(with id: String) -> AnyPublisher<Transaction, NetworkingError>
    func getTransactions(for duration: TransactionDuration) -> AnyPublisher<[DatedTransactions], NetworkingError>
    func getTransactions(fromDate: Date, toDate: Date) -> AnyPublisher<[DatedTransactions], NetworkingError>
}


