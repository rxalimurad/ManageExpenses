//
//  TransactionViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import Foundation

class TransactionViewModel: ObservableObject {
    @Published var transactionsKeys = [String]()
    var transactionsDict = [String: [TransactionModel]]()
    init() {
        var recentTransactions = [
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 499.003, currencySymbol: "$", date: "Sep 03 2022 09:30 pm".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 499.003, currencySymbol: "$", date: "Jan 03 2022 09:30 pm".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 499.003, currencySymbol: "$", date: "Jan 03 2022 09:30 pm".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 499.003, currencySymbol: "$", date: "Jan 03 2022 09:30 pm".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 499.003, currencySymbol: "$", date: "Jan 03 2022 09:30 pm".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 1.3, currencySymbol: "$", date: "Jan 04 2022 10:30 PM".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 454.35, currencySymbol: "$", date: "Jan 05 2022 1:30 PM".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: -4, currencySymbol: "$", date: "Jan 06 2022 10:30 PM".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 35, currencySymbol: "$", date: "Jan 07 2022 10:30 PM".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: -675675, currencySymbol: "$", date: "Jan 08 2022 10:30 PM".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons, JalalSons, JalalSons, JalalSons, JalalSons JalalSons JalalSons JalalSons JalalSons JalalSons", amount: 496759, currencySymbol: "$", date: "Jan 09 2022 10:30 PM".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: 4599, currencySymbol: "$", date: "Jan 10 2022 10:30 PM".toDate()),
            TransactionModel(type: .food, name: "Food", desc: "JalalSons", amount: -499, currencySymbol: "$", date: "Aug 03 2022 10:30 PM".toDate()),
        
        ]
        transactionsDict = getTransactionDict(transactions: recentTransactions)
        
    }
    
    func getTransactionDict(transactions: [TransactionModel]) -> [String: [TransactionModel]] {
        transactionsKeys = []
        let sortedTrans = transactions.sorted(by: { $0.date > $1.date })
        var dict = [String: [TransactionModel]]()
        for trans in sortedTrans {
            if dict[trans.date.dateToShow] == nil {
                dict[trans.date.dateToShow] = [trans]
                transactionsKeys.append(trans.date.dateToShow)
            } else {
                dict[trans.date.dateToShow] = dict[trans.date.dateToShow]! + [trans]
            }
            
        }
        return dict
    }
    
}
