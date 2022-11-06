//
//  FinancialReportCellView.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import SwiftUI

struct FinancialReportCellView: View {
    var analyingData: FinanicalReportModel

    var percentage: Double {
        return (abs(analyingData.amount) / abs(analyingData.total)) * 100
    }
    var body: some View {
        HStack {
            getCategoryTag(category: analyingData.category)
            Spacer()
            Text(Utilities.getFormattedAmount(amount: analyingData.amount))
                .foregroundColor(analyingData.amount > 0 ? .green : .red)
                .font(.system(size: 24, weight: .medium))
        }
        ProgressBarWidgetView(percentage: percentage, color: analyingData.category.color)
    }
    
    func getCategoryTag(category: SelectDataModel) -> some View {
        HStack(spacing: 7) {
            Circle()
                .frame(width: 14, height: 14)
                .foregroundColor(category.color)
            Text(analyingData.category.desc)
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

