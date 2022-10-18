//
//  Date.swift
//  ManageExpenses
//
//  Created by murad on 17/10/2022.
//

import Foundation

extension Date {
    
    var timeToShow: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.format.time
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
    
    var dateToShow: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.format.date
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
    
    
}
