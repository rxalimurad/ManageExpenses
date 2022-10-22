//
//  AmountInputWidget.swift
//  ManageExpenses
//
//  Created by murad on 19/10/2022.
//

import SwiftUI

struct AmountInputWidget: View {
    var amount = ""
    @State private var amountState = ""
    var body: some View {
        ZStack {
            HStack {
                Text("$")
                Text("0")
                    .isShowing(amount.isEmpty)
                    .foregroundColor(CustomColor.baseLight.opacity(0.7))
                Text(getFormattedAmount(amount: amount))
                    .isShowing(!amount.isEmpty)
                
                   
            }.multilineTextAlignment(.leading)
            .padding([.leading], 25)
             
        }
    }
    
    private func getFormattedAmount(amount: String) -> String {
        Utilities.getAmountWith(amount: Double(amount) ?? 0)
    }
}
