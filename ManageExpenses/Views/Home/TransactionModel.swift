//
//  TransactionModel.swift
//  ManageExpenses
//
//  Created by murad on 18/10/2022.
//

import Foundation

struct TransactionModel: Hashable, Identifiable {
    var id: Int
    var category: TransactionCategory
    var name: String
    var desc: String
    var amount: Double
    var currencySymbol: String
    var date: Date
    var type: PlusMenuAction
}
