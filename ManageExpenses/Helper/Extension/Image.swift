//
//  Image.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI

extension Image {
    
    enum Custom {
        static let apple = Image("apple")
        static let google = Image("google")
        static let facebook = Image("facebook")
        static let planMoney = Image("planMoney")
        static let knowMoney = Image("knowMoney")
        static let controlMoney = Image("controlMoney")
        static let circleFill = Image(systemName: "circle.fill")
        static let emailSent = Image("emailSent")
        static let home = Image("home")
        static let bell = Image("bell")
        static let downArrow = Image("downArrow")
        static let transaction = Image("transaction")
        static let inflow = Image("inflow")
        static let outflow = Image("outflow")
        static let filter = Image("filter")
        static let navBack = Image("navBack")
        static let budget = Image("budget")
        static let user = Image("user")
        static let plus = Image(systemName: "plus")
        static let incomeBtn = Image("incomeBtn")
        static let expenseBtn = Image("expenseBtn")
        static let transferBtn = Image("transferBtn")
        static let attachment = Image("attachment")
        static let camera = Image("camera")
        static let gallery = Image("gallery")
        static let file = Image("file")
        static let grayCross = Image("grayCross")
        static let checked = Image(systemName: "checkmark.circle.fill")
        static let unchecked = Image(systemName: "ccheckmark.circle")
        static let transferSign = Image("transferSign")
        static let delete = Image("delete")
        static let edit = Image("edit")
        static let account = Image("account")
        static let settings = Image("settings")
        static let exportData = Image("exportData")
        static let logout = Image("logout")
        static let warning = Image("warning")
        static let aboutus = Image(systemName: "person.2.circle.fill")
        static let appIcon = Image("appicon")
        static let checkedSquared = Image(systemName: "checkmark.square.fill")
        static let unCheckedSquared = Image(systemName: "checkmark.square")
        

        
    }
    
    
    static func getImage(data: Data?) -> Image {
        guard let data = data else { return Image.Custom.downArrow}
        let img: UIImage = UIImage(data: data) ?? UIImage()
        return Image(uiImage: img)
    }
    
}
