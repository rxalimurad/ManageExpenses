//
//  AmountInputWidget.swift
//  ManageExpenses
//
//  Created by murad on 19/10/2022.
//

import SwiftUI

struct AmountInputWidget: View {
    @State private var amount = ""
    @State private var showSheet = false
    var geometry: GeometryProxy
    var body: some View {
        ZStack {
            HStack {
                Group {
                    Text("$")
                    Text("0")
                        .isShowing(amount.isEmpty)
                        .foregroundColor(.gray.opacity(0.8))
                    Text(getFormattedAmount(amount: $amount.wrappedValue))
                        .isShowing(!amount.isEmpty)
                }.onTapGesture {
                    withAnimation {
                        showSheet.toggle()
                    }
                }
            }
            KeyboardWidget(geometry: geometry, amount: $amount, isShowing: $showSheet)
            
        }
    }
    
    private func getFormattedAmount(amount: String) -> String {
        Utilities.getAmountWith(amount: Double(amount) ?? 0)
    }
}
