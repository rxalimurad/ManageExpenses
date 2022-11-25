//
//  Date.swift
//  ManageExpenses
//
//  Created by murad on 17/10/2022.
//

import Foundation

extension Date {
    var secondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(seconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(seconds))
    }
    
    var timeToShow: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.format.time
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    var hour24: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone.current
        return Int(formatter.string(from: self))!
    }
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    var fullMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    var dateToShow: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.format.date
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    var startOfMonth: Date {
        let year = Calendar.current.component(.year, from: self)
        let month = Calendar.current.component(.month, from: self)
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: 1)) ?? self
    }
    
    
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    func getDate(calendar: Calendar = Calendar.current) -> Int {
        let day = String(format: "%02d", calendar.component(Calendar.Component.day, from: self))
        let month = String(format: "%02d", calendar.component(Calendar.Component.month, from: self))
        let year = String(format: "%02d", calendar.component(Calendar.Component.year, from: self))
        let dateCombined = Int("\(year)\(month)\(day)")!
        return dateCombined
    }
    
}
