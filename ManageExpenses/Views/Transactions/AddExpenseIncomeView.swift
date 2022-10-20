//
//  AddExpenseIncomeView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI

struct AddExpenseIncomeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var amount = ""
    var newEntryType: PlusMenuAction
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                getBgColor(type: newEntryType).edgesIgnoringSafeArea(.all)
                VStack {
                    NavigationBar(title: getTitle(type: newEntryType)) {
                        mode.wrappedValue.dismiss()
                    }
                    Spacer()
                    
                    Text("How much?")
                        .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                        .font(.system(size: 18, weight: .medium))
                        .padding([.top], 80)
                        .padding([.leading], 25)
                        .multilineTextAlignment(.leading)
                    
                    AmountInputWidget(geometry: geometry)
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(CustomColor.baseLight_80)
                        .padding([.top], 13)
                        .padding([.leading], 0)
                    Spacer()
                }
                
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
    
    
    
    func getTitle(type: PlusMenuAction) -> String {
        switch type {
        case .income:
            return  "Income"
        case .expense:
            return  "Expense"
        case .convert:
            return  "Transfer"
        }
    }
    func getBgColor(type: PlusMenuAction) -> Color {
        switch type {
        case .income:
            return  CustomColor.green
        case .expense:
            return  CustomColor.red
        case .convert:
            return  CustomColor.blue
        }
    }
    
    
}

struct AddExpenseIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseIncomeView(newEntryType: .income)
    }
}

