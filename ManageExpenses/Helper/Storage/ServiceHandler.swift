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
    func delteTransaction(id: String) -> AnyPublisher<Void, NetworkingError>
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError>
    func addTransfer(transaction: Transaction) -> AnyPublisher<Void, NetworkingError>
    func getTransactions(for duration: TransactionDuration) -> AnyPublisher<([DatedTransactions], String, String), NetworkingError>
    func getTransactions(duration: String, sortBy: SortedBy, filterBy: PlusMenuAction, selectedCat: [String], fromDate: Date, toDate: Date) -> AnyPublisher<[Transaction], NetworkingError>
    func getTransactions(fromDate: Date, toDate: Date) -> AnyPublisher<[DatedTransactions], NetworkingError>
}


