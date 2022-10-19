//
//  AmountInputWidget.swift
//  ManageExpenses
//
//  Created by murad on 19/10/2022.
//

import SwiftUI

struct AmountInputWidget: View {
    @State private var amount = ""
    
    var body: some View {
        
        HStack {
            Text("$")
            TextField("", text: $amount)
               
                .placeholder(when: amount.isEmpty, placeholder: {
                    Text("0")
                })
                .keyboardType(.decimalPad)
                .onChange(of: amount) { _ in
                    let filtered = amount.filter {"0123456789.".contains($0)}
                    if filtered.contains(".") {
                        let splitted = filtered.split(separator: ".", omittingEmptySubsequences: false)
                        if splitted.count >= 2 {
                            let preDecimal = String(splitted[0])
                            let afterDecimal = String(splitted[1])
                            amount = "\(preDecimal).\(afterDecimal)"
                        }
                    }
                }
            
            
            
        }
    }
}
