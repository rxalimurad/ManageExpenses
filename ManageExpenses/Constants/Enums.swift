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

enum TransactionCategory: String {
    case shopping
    case subscription
    case gift
    case car
    case Entertainment
    case pets
    case transfer
    case health
    case transport
    case food
    case eatingOut
    case taxi
    case toiletry
    case communication
    case sports
    case clothes
}

enum FilterSortingBy: String, CaseIterable {
    case hightest
    case lowest
    case newest
    case oldest
}
enum PlusMenuAction: String, CaseIterable {
    case income
    case expense
    case convert
}

enum FilterDuration: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
    case custom = "Custom"
}

