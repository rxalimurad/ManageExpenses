//
//  UIApplication.swift
//  ManageExpenses
//
//  Created by Ali Murad on 02/11/2022.
//

import UIKit
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
