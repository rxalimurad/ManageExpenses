//
//  Transaction.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation

struct Transaction: Identifiable, Hashable {
    let id: String
    let amount: Double
    let category: String
    let desc: String
    let name: String
    let wallet: String
    let attachment: String
    let type: String
    let fromAcc: String
    let toAcc: String
    let date: Date
    
    init(id: String, amount: String, category: String, desc: String, name: String, wallet: String, attachment: String, type: String, fromAcc: String, toAcc: String, date: String) {
        self.amount = Double(amount) ?? 0.0
        self.id = id
        self.category = category
        self.desc = desc
        self.name = name
        self.wallet = wallet
        self.attachment = attachment
        self.type = type
        self.toAcc = toAcc
        self.fromAcc = fromAcc
        self.date = Utilities.getDate(from: date)
    }
    
    func toFireStoreData() -> [String: Any] {
        return [
            "id": id,
            "amount": amount,
            "category": category,
            "desc": desc,
            "name": name,
            "wallet": wallet,
            "attachment": attachment,
            "type": type,
            "toAcc": toAcc,
            "fromAcc" : fromAcc,
            "date" : date
               
        
        ]
    }
    
    static var new = Transaction(id: "", amount: "0.0", category: "", desc: "", name: "", wallet: "", attachment: "", type: "", fromAcc: "", toAcc: "", date: "1667678749")
}

struct DatedTransactions: Hashable {
    let date: String
    let transactions: [Transaction]
    static var new = DatedTransactions(date: "", transactions: [])
}
