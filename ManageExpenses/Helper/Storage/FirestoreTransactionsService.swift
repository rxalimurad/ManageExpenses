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
    func deleteBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.budget)
                    .document(budget.id)
                    .delete { error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchBudgetList() -> AnyPublisher<[BudgetDetail], NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.budget)
                    .getDocuments { snap, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let docs = snap?.documents, !docs.isEmpty {
                                var buds = [BudgetDetail]()
                                for doc in docs {
                                    buds.append(BudgetDetail.getEmptyBudget().fromFireStoreData(data: doc.data()))
                                }
                                promise(.success(buds))
                                
                            } else {
                                promise(.failure(NetworkingError("No documents found")))

                            }
                        }
                    }
                
                    
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    
    func updateBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.budget)
                    .document(budget.id)
                    .setData(budget.toFireStoreData()) {error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    func addTransfer(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                let batch = db.batch()
                let incomeTrans = Transaction(id: "\(UUID())", amount: transaction.amount, category: TransactionCategory.transfer.rawValue, desc: transaction.desc, name: "Transfer from \(transaction.fromAcc)", wallet: transaction.toAcc, attachment: "", type: PlusMenuAction.convert.rawValue, fromAcc: "", toAcc: "", date: transaction.date.secondsSince1970)
                let expenseTrans = Transaction(id: "\(UUID())", amount: -transaction.amount, category: TransactionCategory.transfer.rawValue, desc: transaction.desc, name: "Transfer to \(transaction.toAcc)", wallet: transaction.fromAcc, attachment: "", type: PlusMenuAction.convert.rawValue, fromAcc: "", toAcc: "", date: transaction.date.secondsSince1970)
                
                //add Transaction
                let transRef = db.collection(Constants.firestoreCollection.transactions)
                    .document(incomeTrans.id)
                batch.setData(incomeTrans.toFireStoreData(), forDocument: transRef)
                let transRef2 = db.collection(Constants.firestoreCollection.transactions)
                    .document(expenseTrans.id)
                batch.setData(expenseTrans.toFireStoreData(), forDocument: transRef2)
                // Transfer Amount from Banks
                var fromBankDoc = ""
                var toBankDoc = ""
                for (index, _) in DataCache.shared.banks.enumerated() {
                    if DataCache.shared.banks[index].desc == incomeTrans.wallet {
                        toBankDoc = DataCache.shared.banks[index].id
                        DataCache.shared.banks[index].balance = "\(incomeTrans.amount + Double(DataCache.shared.banks[index].balance!)!)"
                      
                    }
                    if DataCache.shared.banks[index].desc == expenseTrans.wallet {
                        fromBankDoc = DataCache.shared.banks[index].id
                        DataCache.shared.banks[index].balance = "\(expenseTrans.amount + Double(DataCache.shared.banks[index].balance!)!)"
                    }
                }
                let banksRef = db.collection(Constants.firestoreCollection.banks)
                    .document(fromBankDoc)
                let banksRef2 = db.collection(Constants.firestoreCollection.banks)
                    .document(fromBankDoc)
                batch.deleteDocument(banksRef)
                batch.deleteDocument(banksRef2)
                
                if let bank = DataCache.shared.banks.first(where: { $0.id == fromBankDoc }) {
                    batch.setData(bank.toFireStoreData(), forDocument: banksRef)
                }
                if let bank = DataCache.shared.banks.first(where: { $0.id == toBankDoc }) {
                    batch.setData(bank.toFireStoreData(), forDocument: banksRef)
                }
                batch.commit() { error in
                    if let err = error {
                        promise(.failure(NetworkingError(err.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                let batch = db.batch()
                //add Transaction
                let transRef = db.collection(Constants.firestoreCollection.transactions)
                    .document(transaction.id)
                batch.setData(transaction.toFireStoreData(), forDocument: transRef)
                // Delete old bank and add with newValue
                
                var bankDoc = ""
                for (index, _) in DataCache.shared.banks.enumerated() {
                    if DataCache.shared.banks[index].desc == transaction.wallet {
                        bankDoc = DataCache.shared.banks[index].id
                        DataCache.shared.banks[index].balance = "\(transaction.amount + Double(DataCache.shared.banks[index].balance!)!)"
                        break
                    }
                }
                
                let banksRef = db.collection(Constants.firestoreCollection.banks)
                    .document(bankDoc)
                batch.deleteDocument(banksRef)
                
                if let bank = DataCache.shared.banks.first(where: { $0.id == bankDoc }) {
                    batch.setData(bank.toFireStoreData(), forDocument: banksRef)
                }
                batch.commit() { error in
                    if let err = error {
                        promise(.failure(NetworkingError(err.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
                 
            }
        }.eraseToAnyPublisher()
    }
    func delteTransaction(id: String) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future {promise in
                Firestore.firestore().collection(Constants.firestoreCollection.transactions)
                    .document(id)
                    .delete { error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }

    func getTransactions(duration: String,
                         sortBy: SortedBy,
                         filterBy: PlusMenuAction,
                         selectedCat: [String],
                         fromDate: Date,
                         toDate: Date
    ) -> AnyPublisher<[Transaction], NetworkingError> {
        Deferred {
            Future {[weak self] promise in
                guard let self = self else { return }
                self.getCollectionPathForTrans(for: duration, filterBy: filterBy, selectedCat: selectedCat, fromDate: fromDate, toDate: toDate)
                    .getDocuments(completion: { snapshot, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let documents = snapshot?.documents, !documents.isEmpty {
                                var transactions = [Transaction]()
                                for document in documents {
                                    transactions.append(Transaction.new.fromFireStoreData(data: document.data()))
                                }
                                switch sortBy {
                                case .newest:
                                    let sortedTrans = transactions.sorted(by: {$0.date > $1.date })
                                    promise(.success(sortedTrans))
                                case .oldest:
                                    let sortedTrans = transactions.sorted(by: {$0.date < $1.date })
                                    promise(.success(sortedTrans))
                                case .lowest:
                                    let sortedTrans = transactions.sorted(by: {$0.amount > $1.amount })
                                    promise(.success(sortedTrans))
                                case .highest:
                                    let sortedTrans = transactions.sorted(by: {$0.amount < $1.amount })
                                    promise(.success(sortedTrans))
                                }
                                
                                
                            } else {
                                promise(.failure(NetworkingError("No document found")))
                            }
                        }
                        
                        
                    })
            }
        }.eraseToAnyPublisher()
    }
    
    func getTransactions(for duration: TransactionDuration) -> AnyPublisher<([DatedTransactions], String, String), NetworkingError> {
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
                                var income = 0.0
                                var expense = 0.0
                                for document in documents {
                                    let trans = Transaction.new.fromFireStoreData(data: document.data())
                                    if trans.amount > 0 {
                                        income += trans.amount
                                    }
                                    if trans.amount < 0 {
                                        expense += trans.amount
                                    }
                                    transactions.append(trans)
                                }
                                promise(.success((self.proccessTransactions(transactions), "\(income)", "\(expense)")))
                            } else {
                                promise(.failure(NetworkingError("No document found")))
                            }
                        }
                        
                        
                    })
                
            }
        }.eraseToAnyPublisher()
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
    
    func getBanksList() -> AnyPublisher<[SelectDataModel], NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.banks)
                    .getDocuments { snapshot, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let documents = snapshot?.documents, !documents.isEmpty {
                                var banks = [SelectDataModel]()
                                for document in documents {
                                    banks.append(SelectDataModel.new.fromFireStoreData(data: document.data()))
                                }
                                promise(.success(banks))
                                
                            } else {
                                promise(.failure(NetworkingError("No Bank Found")))
                            }
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func saveBank(bank: SelectDataModel) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.banks)
                    .document(bank.id)
                    .setData(bank.toFireStoreData()){ error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    
    //MARK: - Private Helper methods
    
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
        default:
            return Timestamp(date: Date())
        }
        
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
    
    private func getCollectionPath(for duration: TransactionDuration) -> Query {
        let db = Firestore.firestore()
        let collection = db.collection(Constants.firestoreCollection.transactions)
            .whereField("date", isGreaterThanOrEqualTo: getDate(for: duration))
            .whereField("user", isEqualTo: UserDefaults.standard.currentUser?.email ?? "")
        return collection
    }
    private func getCollectionPathForTrans(for duration: String,
                                           filterBy: PlusMenuAction,
                                           selectedCat: [String],
                                           fromDate: Date,
                                           toDate: Date
    ) -> Query {
        var collection = self.getCollectionWithFilterBy(filterBy: filterBy)
        collection = self.getCollectionWithCategory(query: collection, selectedCat: selectedCat)
        collection = self.getCollectionWithRange(query: collection, duration: duration, fromDate: fromDate, toDate: toDate)
            .whereField("user", isEqualTo: UserDefaults.standard.currentUser?.email ?? "")
        
        return collection
    }
    
    
    private func getCollectionWithFilterBy(filterBy: PlusMenuAction) -> Query {
        let db = Firestore.firestore()
        if filterBy == .all {
            return db.collection(Constants.firestoreCollection.transactions)
        } else {
            return db.collection(Constants.firestoreCollection.transactions)
                .whereField("type", isEqualTo: filterBy.rawValue)
        }
    }
    
    private func getCollectionWithCategory(query: Query,  selectedCat: [String]) -> Query {
        if selectedCat.isEmpty {
            return query
        } else {
            return query.whereField("category", in: selectedCat)
        }
    }
    
    private func getCollectionWithRange(query: Query, duration: String, fromDate: Date, toDate: Date) -> Query {
        if let durationFiler = FilterDuration(rawValue: duration), durationFiler == .custom {
            return query
                .whereField("date", isGreaterThanOrEqualTo: fromDate.startOfDay)
                .whereField("date", isLessThanOrEqualTo: toDate.endOfDay)
        }
        return query.whereField("date", isGreaterThanOrEqualTo: getDateForTrans(duration: duration))
    }
    
    private func getDateForTrans(duration: String) -> Timestamp {
        if let filterDur = FilterDuration(rawValue: duration) {
            switch filterDur {
            case .today:
                return self.getDate(for: .thisDay)
            case .thisWeek:
                return self.getDate(for: .thisWeek)
            case .thisMonth:
                return self.getDate(for: .thisMonth)
            case .thisYear:
                return self.getDate(for: .thisYear)
            case .custom:
                return Timestamp(date: Date())
            }
        }
        
        return Timestamp(date: Date())
    }
    
    
    
    
}
