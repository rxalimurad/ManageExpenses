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
    var isSelected: Bool
    
    var body: some View {
        
        VStack {
            HStack(spacing: 15) {
                img?
                    .renderingMode(.template)
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(color)
                    .padding([.vertical], 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image.Custom.checked
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.green)
                    .frame(width: 25, height: 25).isShowing(isSelected)
            }
            .padding([.horizontal], 16)

        }
       
        .background(ColoredView(color: color.opacity(0.2)))
        .cornerRadius(10)
    }
}
