//
//  TransactionView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 17/10/2022.
//

import SwiftUI

struct TransactionView: View {
    var transaction: TransactionModel
    var body: some View {
        
        HStack(alignment: .center) {
            transImageView
            transInfo
            Spacer()
            transInfoAmount
        }
        .frame(maxWidth: .infinity)
        .background(CustomColor.baseLight_60.opacity(0.4))
        .cornerRadius(24)
        .padding([.horizontal], 19)
        
    }
    
    private var transImageView: some View {
        ZStack {
            Color.green.opacity(0.2)
            Image(systemName: "fork.knife")
                .renderingMode(.template)
                .foregroundColor(Color.green)
                .frame(width: 40, height: 40)
        }
        .cornerRadius(17)
        .frame(width: 60, height: 60)
        .padding([.leading], 17)
        .padding([.vertical], 14)
    }

    private var transInfo: some View {
        VStack(alignment: .leading, spacing: 13) {
            Text(transaction.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CustomColor.baseDark_25)
            
            Text(transaction.desc)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
                .lineLimit(1)
        }
    }
    private var transInfoAmount: some View {
        VStack(alignment: .trailing, spacing: 13) {
            Text(Utilities.getFormattedAmount(transaction.currencySymbol, amount: transaction.amount))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(transaction.amount < 0 ? .red : .green)
            
            Text(transaction.date.timeToShow)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
        }
        .padding([.trailing], 16)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: TransactionModel(id: 1, category: .food, name: "Food", desc: "Buy a burger", amount: 34.0, currencySymbol: "₨", date: Date(), type: .income))
    }
}
