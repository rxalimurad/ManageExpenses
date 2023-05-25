//
//  DBHandler.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import Combine


class FirestoreService: ServiceHandlerType {
    
    func addTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
                
            }
        }.eraseToAnyPublisher()
    }
    
    
    func getTransactions(bankId: String) -> AnyPublisher<[Transaction], NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success([]))
                
                
            }
        }.eraseToAnyPublisher()
    }
    
    //MARK: - Banks Service
    func deleteBank(bank: String) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func getBanksList() -> AnyPublisher<[SelectDataModel], NetworkingError> {
        Deferred {
            Future { promise in
                var banks = [SelectDataModel]()
                promise(.success(banks))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveBank(bank: SelectDataModel) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future {[weak self] promise in
                guard let self = self else { return }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    //MARK: - Budgets Service
    
    func fetchBudgetList() -> AnyPublisher<[BudgetDetail], NetworkingError> {
        Deferred {
            Future { promise in
                var buds = [BudgetDetail]()
                promise(.success(buds))
                
                
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateBudget(budget: BudgetDetail) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    
    //MARK: - Transaction Service
    
    func deleteTransaction(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func addTransfer(transaction: Transaction) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
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
        
        var transactions = [Transaction]()
        completion(nil, transactions)
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
