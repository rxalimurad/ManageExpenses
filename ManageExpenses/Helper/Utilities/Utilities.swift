//
//  Utilities.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import Foundation

enum Utilities {
    
    static func getFormattedAmount(_ sym: String, amount: Double) -> String {
        let FAmount = getAmountWith(amount: amount)
        let neg = (amount < 0) ? "-" : ""
        return neg + sym + FAmount
    }
    
    private static func getAmountWith(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        return numberFormatter.string(for: abs(amount)) ?? ""
    }
    
    
}
