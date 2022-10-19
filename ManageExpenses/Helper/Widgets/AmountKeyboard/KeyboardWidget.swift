//
//  KeyboardWidget.swift
//  ManageExpenses
//
//  Created by Ali Murad on 19/10/2022.
//

import SwiftUI

struct KeyboardWidget: View {
    @Binding var amount: String
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Enter Amount")
                TextField("0", text: $amount)
                KeyboardView(amount: $amount)
                    .frame(width: 269, height: 256)
                
            }.foregroundColor(CustomColor.baseDark_50)
                .cornerRadius(20, corners: [.topLeft, .topRight])
        }.foregroundColor(.clear)
    }
}

struct KeyboardWidget_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardWidget(amount: .constant("52"))
    }
}
