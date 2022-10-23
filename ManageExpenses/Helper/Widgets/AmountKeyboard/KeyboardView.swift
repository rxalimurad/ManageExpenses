//
//  KeyboardView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 19/10/2022.
//

import SwiftUI

struct KeyboardView: View {
    @Binding var amount: String
    
    let maxLength = 8
    let precision = 2
    var keys = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], ["•", "0", "<"]]
    var body: some View {
        VStack {
            ForEach(Array(keys.enumerated()), id: \.0) { index, col in
                VStack {
                    HStack {
                        ForEach(Array(col.enumerated()), id: \.0) { (index , element )in
                            Button {
                                amount = getUpdatedAmount(amount: amount, element: element)
                            } label: {
                                Text("\(element)")
                                    .font(.system(size: element == "•" ? 28 : 28 , weight: .regular))
                                    .foregroundColor(CustomColor.baseDark)
                            }
                            Spacer().isShowing(index != (col.count - 1))
                        }
                    }
                    
                    
                }
                Spacer().isShowing(index != keys.count )
            }
        }
        
    }
    
    private func getUpdatedAmount(amount: String, element: String) -> String {
        //,,.. length Check
        var updatedAmount = amount
        if element == "<" {
            if !amount.isEmpty {
                _ = updatedAmount.removeLast()
            }
        } else if element == "•" {
            if !updatedAmount.contains(".") {
                updatedAmount = updatedAmount + "\(updatedAmount.isEmpty ? "0." : ".")"
            }
        } else {
            if isValidAmount(amount: updatedAmount + "\(element)") {
                updatedAmount = updatedAmount + "\(element)"
            }
        }
        
        
        return updatedAmount
    }
    //2.33 33.
    
    private func isValidAmount(amount: String) -> Bool {
        let array = amount.split(separator: ".")
        if array.count == 1 { // not decimal point
            return amount.count <= maxLength
        } else if array.count == 2 {
            return String(array[0]).count <= maxLength && String(array[1]).count <= precision
        } else {
            return false
        }
        
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(amount: .constant("00"))
    }
}
