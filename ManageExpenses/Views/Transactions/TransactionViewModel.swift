//
//  TransactionViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import Foundation

class TransactionViewModel: ObservableObject {
    @Published var transactionsKeys = [String]()
    var transactionsDict = [String: [Transaction]]()
    init() {
        let recentTransactions :[Transaction] = []
        transactionsDict = getTransactionDict(transactions: recentTransactions)
        
    }
    
    func getTransactionDict(transactions: [Transaction]) -> [String: [Transaction]] {
        transactionsKeys = []
        let sortedTrans = transactions.sorted(by: { $0.date! > $1.date! })
        var dict = [String: [Transaction]]()
        for trans in sortedTrans {
            if dict[trans.date!.dateToShow] == nil {
                dict[trans.date!.dateToShow] = [trans]
                transactionsKeys.append(trans.date!.dateToShow)
            } else {
                dict[trans.date!.dateToShow] = dict[trans.date!.dateToShow]! + [trans]
            }
            
        }
        return dict
    }
    
}
