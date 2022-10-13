//
//  Utilities.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import Foundation

class Utilities {
    
    static func getHtml(for htmlType: HTMLType) -> String? {
       let fileName = htmlType.rawValue
        if let filepath = Bundle.main.path(forResource: fileName, ofType: nil) {
            return try? String(contentsOfFile: filepath)
        }
        return nil
    }
    
    
}
