//
//  String.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import Foundation

extension String {
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func vaidateRegex(regex: String) -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: regex)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var digits: [Int] {
        var result = [Int]()
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        return result
    }
    
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.format.date + " " + Constants.format.time
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self) ?? Date()
    }
    
}
