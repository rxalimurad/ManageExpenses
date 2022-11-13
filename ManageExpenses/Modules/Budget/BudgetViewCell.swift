//
//  BudgetViewCell.swift
//  ManageExpenses
//
//  Created by murad on 27/10/2022.
//

import SwiftUI

struct BudgetViewCell: View {
    @Binding var budget: BudgetDetail
    var spending: Double = 1000
    
    var percentage: Double {
        get {
            if spending >= Double(budget.limit)! {
                return 100
            }
            return (spending / Double(budget.limit)!) * 100
        }
    }
    var isLimitExceed: Bool {
        spending > Double(budget.limit)!
    }
    var body: some View {
            VStack {
                HStack {
                    getCategoryTag()
                    Spacer()
                    Image.Custom.warning
                        .isShowing(isLimitExceed)
                }
                .padding([.horizontal, .top], 16)
                Text("Remaining $\(Utilities.getFormattedAmount(amount: Double(budget.limit)! - spending))")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(CustomColor.baseDark)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal], 16)
                    .padding([.top], 8)
                ProgressBarWidgetView(percentage: percentage, color: budget.category.color)
                    .padding([.horizontal], 16)
                    .padding([.top, .bottom], 8)
                    .frame(height: 20)
                Text("\(Utilities.getFormattedAmount(amount: spending)) of \(Utilities.getFormattedAmount(amount: budget.limit))")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(CustomColor.baseLight_20)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal], 16)
                    .padding([.bottom], 8)
                Text("You’ve exceed the limit!")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal], 16)
                    .padding([.bottom], 8)
                    .isShowing(isLimitExceed)
                
            }
            .background(ColoredView(color: CustomColor.baseLight))
        .cornerRadius(15)
        
    }
    
   
    
    func getCategoryTag() -> some View {
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
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(CustomColor.baseLight_20, lineWidth: 1))
            
    }
}

