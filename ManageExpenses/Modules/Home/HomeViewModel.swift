//
//  HomeViewModel.swift
//  ManageExpenses
//
//  Created by murad on 18/10/2022.
//

import Foundation
import CoreData
import SwiftUI

class HomeViewModel: ObservableObject {
    
    var recentTransactionsDict = [String: [Transaction]]()
    func getTransactionDict(transactions: FetchedResults<Transaction>) -> [String] {
        var recentTransactionsKeys: [String] = []
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
        recentTransactionsDict = dict
        return recentTransactionsKeys
    }
    
    func getAccountBalance(trans: FetchedResults<Transaction>) -> String {
        var total = 0.0
        
        for t in trans {
            total += t.transAmount
        }
        return "\(total)"
    }
    func getIncome(trans: FetchedResults<Transaction>) -> String {
        var total = 0.0
        
        for t in trans {
            if t.transAmount > 0 {
            total += t.transAmount
            }
        }
        return "\(total)"
    }
    func getExpense(trans: FetchedResults<Transaction>) -> String {
        var total = 0.0
        
        for t in trans {
            if t.transAmount < 0 {
            total += abs(t.transAmount)
            }
        }
        return "\(total)"
    }
}
