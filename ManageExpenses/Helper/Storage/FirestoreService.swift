//
//  DBHandler.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import SQLite
import FirebaseFirestore
class FirestoreService: ServiceHandlerType {
    static let dbPath = getDBPath()
    
    
    func getTotalBalance() -> String {
        var amount = "0.0"
        let db = try? Connection(FirestoreService.dbPath)
        if let row = try? db?.scalar("SELECT SUM(amount) FROM transactions") {
            amount = "\(row)"
        }
        
        return Utilities.getFormattedAmount(amount: amount)
    }
    
    func getExpense() -> String {
        var amount = "0.0"
        let db = try? Connection(FirestoreService.dbPath)
        let type = "\'expense\'"
        if let row = try? db?.scalar("SELECT SUM(amount) FROM transactions where type = \(type)") {
            amount = "\(row)"
        }
        
        return Utilities.getFormattedAmount(amount: amount)
    }
    
    func getIncome() -> String {
        var amount = "0.0"
        let db = try? Connection(FirestoreService.dbPath)
        let type = "\'income\'"
        if let row = try? db?.scalar("SELECT SUM(amount) FROM transactions where type = \(type)") {
            amount = "\(row)"
        }
        
        return Utilities.getFormattedAmount(amount: amount)
    }
    
    func addTransaction(transaction: Transaction) {
            let db = Firestore.firestore()
            db.collection(Constants.firestoreCollection.transactions)
            .document(transaction.id)
            .setData(transaction.toFireStoreData())
        }
 
    
    func getTransaction(with id: String) -> Transaction {
        do {
            let db = try Connection(FirestoreService.dbPath)
            let transactions = Table("transactions")
            for transaction in try db.prepare(transactions) {
               print(transaction)
            }
        }
        catch {
            return .new
        }
        return .new
    }
    
    func getTransactions(for duration: TransactionDuration) -> [DatedTransactions] {
        do {
            var transactionsList = [Transaction]()
            let db = try Connection(FirestoreService.dbPath)
            let transactions = Table("transactions")
            for transaction in try db.prepare(transactions).filter({ row in
                return false
            }) {
                transactionsList.append(rowToTransaction(row: transaction))
            }
            
            return proccessTransactions(transactionsList)
        }
        catch {
            return []
        }
    
    }
    
    private func checkIfInDuration(duration: FilterDuration, row: Row) {}
    
    func getTransactions(fromDate: Date, toDate: Date) -> [DatedTransactions] {
        return []
    }
    
    private static func getDBPath() -> String {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                               in: .userDomainMask)
        return documentsUrl.first?.appendingPathComponent("InitConfig.db").path ?? ""
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
    private func rowToTransaction(row: Row) -> Transaction {
        let id = row[Expression<Int?>("id")] ?? 0 //,,..
        let fromAcc = row[Expression<String?>("fromAcc")] ?? ""
        let wallet = row[Expression<String?>("wallet")] ?? ""
        let toAcc = row[Expression<String?>("toAcc")] ?? ""
        let category = row[Expression<String?>("category")] ?? ""
        let type = row[Expression<String?>("type")] ?? ""
        let desc = row[Expression<String?>("desc")] ?? ""
        let date = row[Expression<String?>("date")] ?? ""
        let attachment = row[Expression<String?>("attachment")] ?? ""
        let amount = row[Expression<String?>("amount")] ?? ""
        let name = row[Expression<String?>("name")] ?? ""
        
        
        return Transaction(id: "\(id)", amount: amount, category: category, desc: desc, name: name, wallet: wallet, attachment: attachment, type: type, fromAcc: fromAcc, toAcc: toAcc, date: date)
    }
}
