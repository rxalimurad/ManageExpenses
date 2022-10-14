//
//  String.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import Foundation

extension String {
    
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
}
