//
//  SelectorModel.swift
//  ManageExpenses
//
//  Created by murad on 23/10/2022.
//

import Foundation
import SwiftUI

struct SelectDataModel: Identifiable {
    var id: String
    var desc: String
    var balance: String?
    var Image: Image?
    var color = Color.black
    var isSelected = false
    
    
    static let new = SelectDataModel(id: "\(UUID())", desc: "")
    
    func fromFireStoreData(data: [String: Any]) -> SelectDataModel {
        if data.isEmpty {
            return .new
        }
        return SelectDataModel(
            id: data["id"] as! String,
            desc: data["desc"] as! String,
            balance: data["balance"] as? String,
            color: Color(hex: data["color"] as! String)
        )
    }
    
    func toFireStoreData() -> [String: Any] {
        return [
            "id": id,
            "desc": desc,
            "balance": balance,
            "color" : color.hex,
            "user" : UserDefaults.standard.currentUser?.email.lowercased() ?? ""
            
            
        ]
    }
    
}
