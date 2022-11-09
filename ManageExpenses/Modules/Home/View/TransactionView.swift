//
//  TransactionView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 17/10/2022.
//

import SwiftUI

struct TransactionView: View {
    
    var transaction: Transaction
    var showDate: Bool = false
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                transImageView
                    .unskeletonable()
                transInfo
                    .unskeletonable()
                Spacer()
                transInfoAmount
                    .unskeletonable()
            }
            .unskeletonable()
            
        }
        .frame(maxWidth: .infinity)
        .background(CustomColor.baseLight_60.opacity(0.4))
        .cornerRadius(24)
        .padding([.horizontal], 19)
        .unskeletonable()
        
        
    }
    
    private var transImageView: some View {
        ZStack {
            TransactionCategory(rawValue: transaction.category.lowercased())?.getColor().opacity(0.2)
            Image("ic_\(transaction.category.lowercased())")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(TransactionCategory(rawValue: transaction.category.lowercased())?.getColor())
                .frame(width: 33, height: 33)
        }
        .cornerRadius(17)
        .frame(width: 60, height: 60)
        .skeletonable()
        .padding([.leading], 17)
        .padding([.vertical], 14)
    }
    
    private var transInfo: some View {
        VStack(alignment: .leading, spacing: 13) {
            Text(transaction.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CustomColor.baseDark_25)
                .skeletonable()
            
            Text(transaction.desc)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
                .lineLimit(1)
                .skeletonable()
            
        }
    }
    private var transInfoAmount: some View {
        VStack(alignment: .trailing, spacing: 13) {
            Text(Utilities.getFormattedAmount(amount: transaction.amount))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor((transaction.amount) < 0 ? .red : .green)
                .skeletonable()
            
            Group {
                Text(transaction.date.timeToShow)
                +
                Text(showDate ? ("\n" + transaction.date.dateToShow) : "")
                
            }
                .font(.system(size: 13, weight: .medium))
                .multilineTextAlignment(.trailing)
                .foregroundColor(CustomColor.baseLight_20)
                .skeletonable()
            
        }
        .padding([.trailing], 16)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: Transaction(id: "\(UUID())", amount: -25, category: "Food", desc: "Eating food for dinner", name: "Food", wallet: "SadaaPay", attachment: "", type: "expense", fromAcc: "", toAcc: "", date: Date().secondsSince1970))
    }
}
