//
//  BudgetModel.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import Foundation


struct BudgetDetail: Identifiable {
    var id: String
    var category: SelectDataModel
    var limit: String
    var month: String
    var slider: Double
    var recieveAlerts: Bool
    
    
    static func getEmptyBudget() -> BudgetDetail {
        BudgetDetail(id: "\(UUID())", category: .getNewBankAccount(), limit: "", month: Date().month, slider: 50.0, recieveAlerts: false)
    }
    
    func fromFireStoreData(data: [String: Any]) -> BudgetDetail {
        if data.isEmpty {
            return BudgetDetail.getEmptyBudget()
        }
        return BudgetDetail(
            id: data["id"] as! String,
            category: SelectDataModel.getNewBankAccount().fromFireStoreData(data: data["category"] as! [String : Any]),
            limit: data["limit"] as! String,
            month: data["month"] as! String,
            slider: data["slider"] as! Double,
            recieveAlerts: data["recieveAlerts"] as! Bool
        )
    }
    
    func toFireStoreData() -> [String: Any] {
        return [
            "id": id,
            "category": category.toFireStoreData(),
            "limit": limit,
            "month" : month,
            "slider" : slider,
            "recieveAlerts" : recieveAlerts,
            "user" : UserDefaults.standard.currentUser?.email.lowercased() ?? ""
            
            
        ]
    }

    
    
}
