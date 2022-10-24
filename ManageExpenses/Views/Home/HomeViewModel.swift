//
//  HomeViewModel.swift
//  ManageExpenses
//
//  Created by murad on 18/10/2022.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var recentTransactionsKeys = [String]()
    var recentTransactionsDict = [String: [Transaction]]()
    init() {
        let recentTransactions: [Transaction] = [ ]
        recentTransactionsDict = getTransactionDict(transactions: recentTransactions)
        
    }
    
    func getTransactionDict(transactions: [Transaction]) -> [String: [Transaction]] {
        recentTransactionsKeys = []
        let sortedTrans = transactions.sorted(by: { $0.date! > $1.date! })
        var dict = [String: [Transaction]]()
        for trans in sortedTrans {
            if dict[trans.date!.dateToShow] == nil {
                dict[trans.date!.dateToShow] = [trans]
                recentTransactionsKeys.append(trans.date!.dateToShow)
            } else {
                dict[trans.date!.dateToShow] = dict[trans.date!.dateToShow]! + [trans]
            }
            
        }
        return dict
    }
    
}
