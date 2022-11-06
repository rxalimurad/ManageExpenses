//
//  DBHandler.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation

enum TransactionDuration {
    case thisDay
    case thisMonth
    case thisWeek
    case thisYear
}

protocol ServiceHandlerType {
    func getTotalBalance() -> String
    func getExpense() -> String
    func getIncome() -> String
    func addTransaction(transaction: Transaction)
    func getTransaction(with id: String) -> Transaction
    func getTransactions(for duration: TransactionDuration) -> [DatedTransactions]
    func getTransactions(fromDate: Date, toDate: Date) -> [DatedTransactions]
}


