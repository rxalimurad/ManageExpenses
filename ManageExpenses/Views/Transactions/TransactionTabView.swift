//
//  TransactionView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI

struct TransactionTabView: View {
    var safeAreaInsets: EdgeInsets
    
    @ObservedObject var viewModel = TransactionViewModel()
    var body: some View {
        VStack {
            headerView
            subHeader
            transactions
        }
        
    }
    
    
    
    var subHeader: some View {
        HStack {
            Text("See your financial report")
                .foregroundColor(CustomColor.primaryColor)
                .font(.system(size: 16, weight: .medium))
                .padding([.vertical], 15)
            Spacer()
            Image.Custom.downArrow.rotationEffect(Angle(degrees: 270))
        }.padding([.horizontal], 16)
            .background(CustomColor.primaryColor_20)
    }
    
    var transactions: some View {
        ScrollView {
            ForEach(viewModel.transactionsKeys, id: \.self) { headerTransDate in
                Text(headerTransDate)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(CustomColor.baseDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal], 19)
                ForEach(viewModel.transactionsDict[headerTransDate]!, id: \.self) { transaction in
                    TransactionView(transaction: transaction)
                }
            }
        }
    }
    
    var headerView: some View {
        VStack {
            HStack(alignment: .center) {
               
                HStack(alignment: .center) {
                    Image.Custom.downArrow
                        .padding([.leading ], 13)
                    Text("This Month")
                        .font(.system(size: 14, weight: .medium))
                        .padding([.top,.bottom], 11)
                        .padding([.trailing], 16)
                }
                .padding([.leading], 16)
                .overlay(RoundedRectangle(cornerRadius: 40, style: .circular)
                    .stroke(CustomColor.baseLight_60, lineWidth: 1)
                )
                
                Spacer()
                Image.Custom.filter
                    .padding([.trailing], 21)
            }.padding([.top, .bottom], 12)
                .padding([.top], safeAreaInsets.top)
            
            
                .padding([.leading, .trailing], 16)
            
            
        }.cornerRadius(15)
    }
    
    
}




struct TransactionTabView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionTabView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}