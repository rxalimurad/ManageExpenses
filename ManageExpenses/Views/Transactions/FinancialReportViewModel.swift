//
//  FinancialReportViewModel.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import Foundation
import CoreData
import SwiftUI
class FinancialReportViewModel: ObservableObject {
    @State var categoryData = [SelectDataModel(id: "1", desc: "Food", Image: .Custom.camera, color: .red),
                               SelectDataModel(id: "2", desc: "Fuel", Image: .Custom.bell, color: .green),
                               SelectDataModel(id: "3", desc: "Shopping", Image: .Custom.bell, color: .yellow),
                               SelectDataModel(id: "4", desc: "Clothes", Image: .Custom.bell, color: .blue),
                               SelectDataModel(id: "5", desc: "Fee", Image: .Custom.bell, color: .black)]
    
    func getFinanicalData(transactions: FetchedResults<Transaction>) -> [FinanicalReportModel] {
        let total = getExpense(trans: transactions)
        
        var reportModel = categoryData.map({
            return FinanicalReportModel(category: $0, amount: 0, total: total)
        })
        
        for i in 0 ..< transactions.count {
            if transactions[i].transAmount < 0 {
                for j in 0 ..< reportModel.count {
                    if reportModel[j].category.desc == transactions[i].transName {
                        reportModel[j].amount += transactions[i].transAmount
                        break
                    }
                }
            }
        }
        
        
        
        return reportModel
    }
    func getIncome(trans: FetchedResults<Transaction>) -> Double {
        var total = 0.0
        
        for t in trans {
            if t.transAmount > 0 {
            total += t.transAmount
            }
        }
        return total
    }
    func getExpense(trans: FetchedResults<Transaction>) -> Double {
        var total = 0.0
        
        for t in trans {
            if t.transAmount < 0 {
            total += abs(t.transAmount)
            }
        }
        return total
    }
    
}
