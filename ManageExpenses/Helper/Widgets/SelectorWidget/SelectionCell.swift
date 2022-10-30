//
//  SelectorCell.swift
//  ManageExpenses
//
//  Created by murad on 22/10/2022.
//


import SwiftUI

struct SelectionCell: View {
    var title: String
    var color: Color
    var img: Image?
    var balance: String?
    var isSelected: Bool
    
    var body: some View {
        
        VStack {
            HStack(spacing: 15) {
                img?
                    .renderingMode(.template)
                    .foregroundColor(color)
                if img == nil {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(color)
                }
                if balance == nil {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(CustomColor.baseDark)
                    .padding([.vertical], 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Group {
                        Text(title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(CustomColor.baseDark)
                            
                        +
                        Text("  (\(balance!))")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(CustomColor.baseLight_20)
                            
                    }
                    .padding([.vertical], 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                }
                Image.Custom.checked
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.green)
                    .frame(width: 25, height: 25).isShowing(isSelected)
            }
            .padding([.horizontal], 16)

        }
       
        .background(ColoredView(color: CustomColor.baseLight))
        .cornerRadius(10)
    }
}
