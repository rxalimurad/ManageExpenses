//
//  SingleFilterSelectionView.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import SwiftUI

struct SingleFilterSelectionView: View {
    @Binding var selectedOpts: String
    var options: [String]
    let columns = [
           GridItem(.flexible()),
           GridItem(.flexible()),
           GridItem(.flexible()),
       ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
        ForEach(options, id: \.self) { option in
            Button {
                withAnimation {
                    selectedOpts = option
                }
            } label: {
                ZStack {
                    CustomColor.primaryColor
                        .opacity(option == selectedOpts ? 0.2 : 0.0)
                        .cornerRadius(20)
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(CustomColor.baseLight_20, lineWidth: option == selectedOpts ? 0 : 1)
                    Text(option.capitalized)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(option == selectedOpts ? CustomColor.primaryColor : CustomColor.baseDark)
                        .padding([.vertical], 12)
                }
            }

        }
        }
    }
}

struct SingleFilterSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SingleFilterSelectionView(selectedOpts: .constant(PlusMenuAction.expense.rawValue), options: ["1", "2"])
    }
}
