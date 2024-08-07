//
//  DBHandler.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class FirestoreService: ServiceHandlerType {
    
    func deleteAccount(completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
        
        let group = DispatchGroup()
        var deleteError: Error?
        
        // Function to delete all documents in a subcollection
        func deleteCollection(_ collectionRef: CollectionReference, completion: @escaping (Error?) -> Void) {
            collectionRef.getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    completion(error)
                    return
                }
                let batch = db.batch()
                for document in documents {
                    batch.deleteDocument(document.reference)
                }
                batch.commit(completion: completion)
            }
        }
        
        // Delete 'banks' subcollection
        group.enter()
        deleteCollection(userRef.collection(Constants.firestoreCollection.banks)) { error in
            if let error = error {
                deleteError = error
            }
            group.leave()
        }
        
        // Delete 'budget' subcollection
        group.enter()
        deleteCollection(userRef.collection(Constants.firestoreCollection.budget)) { error in
            if let error = error {
                deleteError = error
            }
            group.leave()
        }
        
        // Delete 'transactions' subcollection
        group.enter()
        deleteCollection(userRef.collection(Constants.firestoreCollection.transactions)) { error in
            if let error = error {
                deleteError = error
            }
            group.leave()
        }
        
        // Once all subcollections are deleted, delete the user document
        group.notify(queue: .main) {
            if let deleteError = deleteError {
                completion?(deleteError)
            } else {
                userRef.delete(completion: completion)
            }
        }
    }

    func getTransactions(bankId: String) -> AnyPublisher<[Transaction], NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                userRef.collection(Constants.firestoreCollection.transactions)
                    .whereField("wallet", isEqualTo: bankId)
                    .getDocuments { snapshot, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let documents = snapshot?.documents, !documents.isEmpty {
                                var trans = [Transaction]()
                                for document in documents {
                                    trans.append(Transaction.new.fromFireStoreData(data: document.data()))
                                }
                                promise(.success(trans))
                                
                            } else {
                                promise(.success([]))
                            }
                        }
                    }
                
                
            }
        }.eraseToAnyPublisher()
    }
    
    //MARK: - Banks Service
    func deleteBank(bank: String) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                guard let uid = Auth.auth().currentUser?.uid else {
                              promise(.failure(NetworkingError("User not authenticated")))
                              return
                          }
                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                userRef.collection(Constants.firestoreCollection.banks)
                    .document(bank)
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
    
    func getBanksList() -> AnyPublisher<[SelectDataModel], NetworkingError> {
        Deferred {
            Future { promise in
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                let db = Firestore.firestore()

                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                userRef.collection(Constants.firestoreCollection.banks)
                    .getDocuments { snapshot, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let documents = snapshot?.documents, !documents.isEmpty {
                                var banks = [SelectDataModel]()
                                for document in documents {
                                    banks.append(SelectDataModel.getNewBankAccount().fromFireStoreData(data: document.data()))
                                }
                                promise(.success(banks))
                                
                            } else {
                                promise(.success([]))
                            }
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func saveBank(bank: SelectDataModel) -> AnyPublisher<Void, NetworkingError> {
        
        Deferred {
            Future {[weak self] promise in
                guard let self = self else { return }
                guard (Auth.auth().currentUser?.uid) != nil else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let db = Firestore.firestore()
                let batch = db.batch()
                
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                let bankRef = userRef.collection(Constants.firestoreCollection.banks).document(bank.id)
                batch.setData(bank.toFireStoreData(), forDocument: bankRef)
                if let transaction = self.getTransactionForSavingBank(bank: bank) {
                    let transRef = userRef.collection(Constants.firestoreCollection.transactions)
                        .document(transaction.id)
                    batch.setData(transaction.toFireStoreData(), forDocument: transRef)
                }
                batch.commit() { error in
                    if let err = error {
                        promise(.failure(NetworkingError(err.localizedDescription)))
                    } else {
                        if DataCache.shared.banks.first(where: {$0.id == bank.id}) != nil {
                            for (i, oldBank) in DataCache.shared.banks.enumerated() {
                                if oldBank.id == bank.id {
                                    DataCache.shared.banks[i] = bank
                                    break
                                }
                            }
                            
                        } else {
                            DataCache.shared.banks.append(bank)
                        }
                        promise(.success(()))
                        
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    //MARK: - Budgets Service
    
    func fetchBudgetList() -> AnyPublisher<[BudgetDetail], NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                userRef.collection(Constants.firestoreCollection.budget)
                    .whereField("month", isEqualTo: Date().month)
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
                                promise(.success([]))
                                
                            }
                        }
                    }
                
                
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                userRef.collection(Constants.firestoreCollection.budget)
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
    
    func updateBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                userRef.collection(Constants.firestoreCollection.budget)
                    .document(budget.id)
                    .setData(budget.toFireStoreData()) {[weak self] error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            self?.saveBudget(budget: budget)
                            promise(.success(()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    
    //MARK: - Transaction Service
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                
                
                let dbf = Firestore.firestore()
                
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let db = dbf.collection(Constants.firestoreCollection.users).document(uid)
                
                let batch = dbf.batch()
                //add Transaction
                let transRef = db.collection(Constants.firestoreCollection.transactions)
                    .document(transaction.id)
                batch.setData(transaction.toFireStoreData(), forDocument: transRef)
                // Delete old bank and add with newValue
                
                var bankDoc = ""
                for (index, _) in DataCache.shared.banks.enumerated() {
                    if DataCache.shared.banks[index].id == transaction.wallet {
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
                        if transaction.amount < 0 {
                            if DataCache.shared.catSpendingDict[transaction.category.lowercased()] == nil {
                                DataCache.shared.catSpendingDict[transaction.category.lowercased()] = abs(transaction.amount)
                            } else {
                                DataCache.shared.catSpendingDict[transaction.category.lowercased()]! += abs(transaction.amount)
                            }
                        }
                        promise(.success(()))
                    }
                }
                
            }
        }.eraseToAnyPublisher()
    }
    func deleteTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future {promise in
                let dbf = Firestore.firestore()
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let db = dbf.collection(Constants.firestoreCollection.users).document(uid)
                let batch = dbf.batch()
                //delete Transaction
                let transRef = db.collection(Constants.firestoreCollection.transactions)
                    .document(transaction.id)
                batch.deleteDocument(transRef)
                var bankDoc = ""
                for (index, _) in DataCache.shared.banks.enumerated() {
                    if DataCache.shared.banks[index].id == transaction.wallet {
                        bankDoc = DataCache.shared.banks[index].id
                        DataCache.shared.banks[index].balance = "\(-transaction.amount + Double(DataCache.shared.banks[index].balance!)!)"
                        break
                    }
                }
                let banksRef = db.collection(Constants.firestoreCollection.banks)
                    .document(bankDoc)
                batch.deleteDocument(banksRef)
                
                if let bank = DataCache.shared.banks.first(where: { $0.id == bankDoc }) {
                    batch.setData(bank.toFireStoreData(), forDocument: banksRef)
                }
                batch.commit() {
                    error in
                    if let err = error {
                        promise(.failure(NetworkingError(err.localizedDescription)))
                    } else {
                        if transaction.amount < 0 {
                            if transaction.date >= Date().startOfMonth {
                                if DataCache.shared.catSpendingDict[transaction.category.lowercased()] != nil {
                                    DataCache.shared.catSpendingDict[transaction.category.lowercased()]! -= abs(transaction.amount)
                                }
                            }
                        }
                        promise(.success(()))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func addTransfer(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let dbf = Firestore.firestore()
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                
                let db = dbf.collection(Constants.firestoreCollection.users).document(uid)
                let batch = dbf.batch()
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
    func getTransactions(duration: String,
                         sortBy: SortedBy,
                         filterBy: PlusMenuAction,
                         selectedCat: [String],
                         fromDate: Date,
                         toDate: Date,
                         completion: @escaping (NetworkingError?, [Transaction]?) -> Void) {
        //,,..
        self.getCollectionPathForTrans(for: duration, filterBy: filterBy, selectedCat: selectedCat, fromDate: fromDate, toDate: toDate)?
            .addSnapshotListener { snapshot, error in
                if let err = error {
                    completion(NetworkingError(err.localizedDescription), nil)
                } else {
                    if let documents = snapshot?.documents, !documents.isEmpty {
                        var transactions = [Transaction]()
                        for document in documents {
                            transactions.append(Transaction.new.fromFireStoreData(data: document.data()))
                        }
                        completion(nil, self.getSortedTransactions(sortBy: sortBy, transactions: transactions))
                    } else {
                        completion(NetworkingError("No document found"), nil)
                    }
                }
                
                
            }
    }
    
}



//MARK: - Private Helper methods

extension FirestoreService {
    
    private func getTransactionForSavingBank(bank: SelectDataModel) -> Transaction? {
        let transId = "\(UUID())"
        let sym = UserDefaults.standard.currency
        if let existingBank = DataCache.shared.banks.first(where: {$0.id == bank.id}) {
            if existingBank.balance == bank.balance {
                return nil
            } else {
                return Transaction(id: transId, amount: Double(bank.balance ?? "0")! - Double(existingBank.balance ?? "0")!, category: TransactionCategory.transfer.rawValue, desc: "Bank Account edited with \(sym)\(bank.balance ?? "0") new balance.", name: "Bank Edited", wallet: bank.desc, attachment: "", type: "Bank Edited", fromAcc: "", toAcc: "", date: Date().secondsSince1970)
            }
        } else {
            return Transaction(id: transId, amount: Double(bank.balance ?? "0")!, category: TransactionCategory.transfer.rawValue, desc: "Bank Account added with \(sym)\(bank.balance ?? "0") balance.", name: "Bank Added", wallet: bank.desc, attachment: "", type: "Bank Added", fromAcc: "", toAcc: "", date: Date().secondsSince1970)
        }
    }
    
    
    private func getDate(for duration: TransactionDuration) -> Timestamp {
        switch duration {
        case .thisDay:
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let start = Calendar.current.date(from: components) ?? Date()
            return Timestamp(date: start)
        case .thisMonth:
            return Timestamp(date: Date().startOfMonth)
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
    
    private func getCollectionPath(for duration: TransactionDuration) -> Query {
        let db = Firestore.firestore()
        let collection = db.collection(Constants.firestoreCollection.transactions)
            .whereField("date", isGreaterThanOrEqualTo: getDate(for: duration))
        return collection
    }
    private func getCollectionPathForTrans(for duration: String,
                                           filterBy: PlusMenuAction,
                                           selectedCat: [String],
                                           fromDate: Date,
                                           toDate: Date
    ) -> Query? {
        
        guard var collection = self.getCollectionWithFilterBy(filterBy: filterBy) else { return nil }
        collection = self.getCollectionWithCategory(query: collection, selectedCat: selectedCat)
        collection = self.getCollectionWithRange(query: collection, duration: duration, fromDate: fromDate, toDate: toDate)
        
        return collection
    }
    
    
    private func getCollectionWithFilterBy(filterBy: PlusMenuAction) -> Query? {
        let dbf = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        let db = dbf.collection(Constants.firestoreCollection.users).document(uid)
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
    
    private func getSortedTransactions(sortBy: SortedBy, transactions: [Transaction]) -> [Transaction] {
        switch sortBy {
        case .newest:
            let sortedTrans = transactions.sorted(by: {$0.date > $1.date })
            return sortedTrans
        case .oldest:
            let sortedTrans = transactions.sorted(by: {$0.date < $1.date })
            return sortedTrans
        case .lowest:
            let sortedTrans = transactions.sorted(by: {$0.amount > $1.amount })
            return sortedTrans
        case .highest:
            let sortedTrans = transactions.sorted(by: {$0.amount < $1.amount })
            return sortedTrans
        }
    }
    
    private func saveBudget(budget: BudgetDetail) {
        for i in 0 ..< DataCache.shared.budget.count {
            if DataCache.shared.budget[i].id == budget.id {
                DataCache.shared.budget[i] = budget
                return
            }
        }
        DataCache.shared.budget.append(budget)
    }
}
