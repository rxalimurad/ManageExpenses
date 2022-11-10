//
//  Utilities.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import Foundation
import SwiftUI

enum Utilities {
    
    
    static func getDate(from interval: String) -> Date {
        Date(seconds: Int64(interval)!)
    }
    
    static func getFormattedAmount(amount: Double) -> String {
        let FAmount = getAmountWith(amount: amount)
        let neg = (amount < 0) ? "-" : ""
        return neg + UserDefaults.standard.currency + FAmount
    }
    static func getFormattedAmount(amount: String) -> String {
        if let doubleAmount = Double(amount) {
            return getFormattedAmount(amount: doubleAmount)
        }
        return getFormattedAmount(amount: 0.0)
    }
    
     private static func getAmountWith(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        return numberFormatter.string(for: abs(amount)) ?? ""
    }
    
    internal static func getCategories() -> [SelectDataModel] {
        var casesArr = TransactionCategory.allCases
        var categories = [SelectDataModel]()
        casesArr.removeAll(where: {$0 == .transfer})
        for category in casesArr {
            if TransactionCategory.eatingout == category {
                categories.append(SelectDataModel(id: category.rawValue, desc: "Eating Out", Image: Image("ic_\(category.rawValue.lowercased())"), color: category.getColor()))
            } else {
                categories.append(SelectDataModel(id: category.rawValue, desc: category.rawValue.capitalized, Image: Image("ic_\(category.rawValue.lowercased())"), color: category.getColor()))
            }
            
        }
        return categories
    }
    
}
