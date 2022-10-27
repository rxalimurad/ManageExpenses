//
//  BudgetViewCell.swift
//  ManageExpenses
//
//  Created by murad on 27/10/2022.
//

import SwiftUI
import WrappingHStack

struct BudgetViewCell: View {
    var budget: BudgetDetail
    var body: some View {
       // ZStack {
           // Color.yellow.opacity(0.2)
            VStack {
                WrappingHStack {
                    getCategoryTag()
                        .frame(height: 33)
                        .frame(maxWidth: 200)
                    Spacer()
                    Image.Custom.warning
                }
                .padding([.horizontal, .top], 16)
            }
//        }
//        .cornerRadius(15)
    }
    
    func getCategoryTag() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(CustomColor.baseLight_20, lineWidth: 1)
            HStack(spacing: 7) {
                Circle()
                    .frame(width: 14, height: 14)
                    .foregroundColor(budget.category.color)
                Text(budget.category.desc)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(CustomColor.baseDark)
                    .padding([.trailing], 16)
            }
            .padding([.vertical,.leading], 8)
            
        }
    }
}

struct BudgetViewCell_Previews: PreviewProvider {
    static var previews: some View {
        BudgetViewCell(budget: BudgetDetail(category: SelectDataModel(id: "2", desc: "Food", Image: nil, color: .red, isSelected: false), limit: 200))
    }
}
