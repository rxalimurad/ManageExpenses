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
    
    var body: some View {
        
        VStack {
            Text(title)
                .frame(maxWidth: .infinity)
                .foregroundColor(color)
                .padding([.all], 16)

        }
       
        .background(ColoredView(color: color.opacity(0.2)))
        .cornerRadius(10)
    }
}
