//
//  AmountInputWidget.swift
//  ManageExpenses
//
//  Created by murad on 19/10/2022.
//

import SwiftUI

struct AmountInputWidget: View {
    var amount = ""
    var leading: CGFloat = 25
    var body: some View {
        ZStack {
            HStack {
                Text("$")
                Text("0")
                    .isShowing(amount.isEmpty)
                    .foregroundColor(CustomColor.baseLight.opacity(0.7))
                Text(getFormattedAmount(amount: amount, showSym: false))
                    .isShowing(!amount.isEmpty)
                
                   
            }.multilineTextAlignment(.leading)
            .padding([.leading], leading)
             
        }
    }
    
    private func getFormattedAmount(amount: String, showSym: Bool) -> String {
        Utilities.getFormattedAmount(amount: Double(amount) ?? 0, showSym: showSym)
    }
}
