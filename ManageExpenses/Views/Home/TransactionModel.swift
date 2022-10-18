//
//  TransactionModel.swift
//  ManageExpenses
//
//  Created by murad on 18/10/2022.
//

import Foundation

struct TransactionModel: Hashable {
    var type: TransactionType
    var name: String
    var desc: String
    var amount: Double
    var currencySymbol: String
    var date: Date
}
