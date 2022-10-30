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
    
}
