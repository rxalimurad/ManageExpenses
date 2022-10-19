//
//  KeyboardView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 19/10/2022.
//

import SwiftUI

struct KeyboardView: View {
    @Binding var amount: String
    var keys = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], ["•", "0", "<"]]
    var body: some View {
        VStack {
            ForEach(Array(keys.enumerated()), id: \.0) { index, col in
                 VStack {
                    HStack {
                        ForEach(Array(col.enumerated()), id: \.0) { (index , element )in
                            Button {
                                amount = amount + "\(element)"
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
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(amount: .constant("00"))
    }
}
