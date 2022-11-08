//
//  DBHandler.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import Combine
import FirebaseFirestore
class FirestoreService: ServiceHandlerType {
    
    
    func getTotalBalance() -> String {
        "0"
    }
    
    func getExpense() -> String {
        "0"
    }
    
    func getIncome() -> String {
        "0"
    }
    
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.transactions)
                    .document(transaction.id)
                    .setData(transaction.toFireStoreData()){ error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getTransaction(with id: String) -> AnyPublisher<Transaction, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.transactions)
                    .document(id)
                    .setData([:]){ error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success((Transaction.new)))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func getTransactions(for duration: TransactionDuration) -> AnyPublisher<[DatedTransactions], NetworkingError> {
        Deferred {
            Future {[weak self] promise in
                guard let self = self else { return }
                self.getCollectionPath(for: duration)
                    .getDocuments(completion: { snapshot, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let documents = snapshot?.documents, !documents.isEmpty {
                                var transactions = [Transaction]()
                                for document in documents {
                                    transactions.append(Transaction.new.fromFireStoreData(data: document.data()))
                                }
                                promise(.success(self.proccessTransactions(transactions)))
                            } else {
                                promise(.failure(NetworkingError("No document found")))
                            }
                        }
                        
                        
                    })
                
            }
        }.eraseToAnyPublisher()
    }
    
    private func getCollectionPath(for duration: TransactionDuration) -> Query {
        let db = Firestore.firestore()
        let collection = db.collection(Constants.firestoreCollection.transactions)
            .whereField("date", isGreaterThanOrEqualTo: getDate(for: duration))
        return collection
    }
    private func getDate(for duration: TransactionDuration) -> Timestamp {
        switch duration {
        case .thisDay:
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let start = Calendar.current.date(from: components) ?? Date()
            return Timestamp(date: start)
        case .thisMonth:
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let thisMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1)) ?? Date()
            return Timestamp(date: thisMonth)
        case .thisWeek:
            let thisWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return Timestamp(date: thisWeek)
        case .thisYear:
            let year = Calendar.current.component(.year, from: Date())
            let thisYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))  ?? Date()
            return Timestamp(date: thisYear)
            
        }
        
    }
    
    
    func getTransactions(fromDate: Date, toDate: Date) -> AnyPublisher<[DatedTransactions], NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.transactions)
                    .document("id")
                    .setData([:]){ error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success(([DatedTransactions]())))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    private func proccessTransactions(_ transactions: [Transaction]) -> [DatedTransactions] {
        var recentTransactionsKeys: [String] = []
        let sortedTrans = transactions.sorted(by: { $0.date > $1.date })
        var dict = [String: [Transaction]]()
        for trans in sortedTrans {
            if dict[trans.date.dateToShow] == nil {
                dict[trans.date.dateToShow] = [trans]
                recentTransactionsKeys.append(trans.date.dateToShow)
            } else {
                dict[trans.date.dateToShow] = dict[trans.date.dateToShow]! + [trans]
            }
        }
        var list = [DatedTransactions]()
        for key in recentTransactionsKeys {
            let obj = dict[key]!
            list.append(DatedTransactions(date: key, transactions: obj))
        }
        
        
        return list
    }
    
    
    
}
