//
//  TransactionView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 17/10/2022.
//

import SwiftUI
//60*60
//40*40
struct TransactionView: View {
    var transType: TransactionType
    var transName: String
    var transDesc: String
    var body: some View {
        
        HStack(alignment: .center) {
            transImageView
            VStack(alignment: .leading, spacing: 13) {
                Text(transName)
                    .font(.system(size: 16, weight: .medium))
                
                Text(transDesc)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(CustomColor.baseLight_60)
        .cornerRadius(24)
        
    }
    
    var transImageView: some View {
        ZStack {
            Color.green.opacity(0.2)
            Image(systemName: "fork.knife")
                .frame(width: 40, height: 40)
        }
        .cornerRadius(17)
        .frame(width: 60, height: 60)
        .padding([.leading], 17)
        .padding([.vertical], 14)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transType: .food, transName: "Food", transDesc: "Buy a burger")
    }
}
