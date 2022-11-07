//
//  Transaction.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import FirebaseFirestore
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
    
    init(id: String, amount: Double, category: String, desc: String, name: String, wallet: String, attachment: String, type: String, fromAcc: String, toAcc: String, date: Int64) {
        self.amount = amount
        self.id = id
        self.category = category
        self.desc = desc
        self.name = name
        self.wallet = wallet
        self.attachment = attachment
        self.type = type
        self.toAcc = toAcc
        self.fromAcc = fromAcc
        self.date = Utilities.getDate(from: "\(date)")
    }
    
    
    func fromFireStoreData(data: [String: Any]) -> Transaction {
        if data.isEmpty {
            return .new
        }
        return Transaction(
            id: data["id"] as! String,
            amount: data["amount"] as! Double,
            category: data["category"] as! String,
            desc: data["desc"] as! String,
            name: data["name"] as! String,
            wallet: data["wallet"] as! String,
            attachment: data["attachment"] as! String,
            type: data["type"] as! String,
            fromAcc: data["fromAcc"] as! String,
            toAcc: data["toAcc"] as! String,
            date: (data["date"] as! Timestamp).seconds
        )
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
    
    static var new = Transaction(id: "Dummy", amount: 0.0, category: "Dummy", desc: "DummyDummyDummyDummyDummy", name: "Dummy", wallet: "", attachment: "", type: "", fromAcc: "", toAcc: "", date: 1667678749)
}

struct DatedTransactions: Hashable {
    let date: String
    let transactions: [Transaction]
    static var new = DatedTransactions(date: "Dummy", transactions: [Transaction.new, Transaction.new, Transaction.new, Transaction.new])
}
