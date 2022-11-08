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
        formatter.dateFormat = "hh"
        formatter.timeZone = TimeZone.current
        return Int(formatter.string(from: self))!
    }
    
    var dateToShow: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.format.date
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
          return calendar.component(component, from: self)
      }
      
}
