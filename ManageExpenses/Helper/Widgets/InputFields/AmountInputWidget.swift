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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Group {
                        Text("$")
                        Text("0")
                            .isShowing(amount.isEmpty)
                            .foregroundColor(.gray.opacity(0.8))
                        Text($amount.wrappedValue)
                            .isShowing(!amount.isEmpty)
                    }.onTapGesture {
                        withAnimation {
                            showSheet.toggle()
                        }
                    }
                }
                KeyboardWidget(geometry: geometry, amount: $amount, isShowing: $showSheet)
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
