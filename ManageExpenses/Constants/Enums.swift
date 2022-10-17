//
//  Enums.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import Foundation

enum HTMLType: String {
    case terms = "termAndCondition.html"
    
    func getHtml() -> String? {
       let fileName = self.rawValue
        if let filepath = Bundle.main.path(forResource: fileName, ofType: nil) {
            return try? String(contentsOfFile: filepath)
        }
        return nil
    }
}

enum TransactionType: String {
    case shopping
    case subscription
    case salary
    case transport
    case food
}

