//
//  BottomSelectionCellView.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import SwiftUI

struct BottomSelectionCellView: View {
    var title: String
    var action: () -> Void
    var body: some View {
        VStack {
            VStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(CustomColor.primaryColor)
            }
           
            .padding([.top], 20)
            .padding([.bottom], 16)
            .frame(maxWidth: .infinity)
        }
        .background(ColoredView(color: CustomColor.primaryColor.opacity(0.2)))
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
    }
}

struct BottomSelectionCellView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSelectionCellView(title: "jhhk") {}
    }
}
