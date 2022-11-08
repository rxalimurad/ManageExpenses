//
//  Enums.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI

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

enum TransactionCategory: String, CaseIterable {
    case shopping
    case subscription
    case gift
    case car
    case entertainment
    case pets
    case transfer
    case health
    case transport
    case food
    case eatingout
    case taxi
    case toiletry
    case communication
    case sports
    case clothes
    
    func getColor() -> Color {
        switch self {
            
        case .shopping:
            return Color.red
        case .subscription:
            return Color.green
        case .gift:
            return Color.purple
        case .car:
            return Color.black
        case .entertainment:
            return Color.yellow
        case .pets:
            return Color.pink
        case .transfer:
            return Color.blue
        case .health:
            return Color(red: 2/255, green: 200/255, blue: 123/255)
        case .transport:
            return Color.orange
        case .food:
            return Color(red: 123/255, green: 200/255, blue: 2/255)
        case .eatingout:
            return Color(red: 25/255, green: 123/255, blue: 20/255)
        case .taxi:
            return Color(red: 125/255, green: 23/255, blue: 200/255)
        case .toiletry:
            return Color(red: 250/255, green: 73/255, blue: 90/255)
        case .communication:
            return Color(red: 35/255, green: 141/255, blue: 45/255)
        case .sports:
            return Color(red: 68/255, green: 141/255, blue: 69/255)
        case .clothes:
            return Color(red: 135/255, green: 41/255, blue: 145/255)
        }
    }
    
    
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

enum UserKeys: String {
    case name
    case email
}
enum ServiceAPIState {
    case successful
    case inprogress
    case failed(error: NetworkingError)
    case na
}
