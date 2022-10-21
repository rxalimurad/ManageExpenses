//
//  AddExpenseIncomeView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI

struct AddExpenseIncomeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showSheet = false
    @State var isRepeated = false
    @State var amount = ""
    @State private var phase = 0.0
    
    
    var newEntryType: PlusMenuAction
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                NavigationBar(title: getTitle(type: newEntryType), top: geometry.safeAreaInsets.top) {
                    mode.wrappedValue.dismiss()
                }
                Spacer()
                Text("Income")
                    .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                    .font(.system(size: 18, weight: .medium))
                    .padding([.leading], 26)
                AmountInputWidget(amount: amount)
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(CustomColor.baseLight)
                    .padding([.top], 13)
                    .onTapGesture {
                        withAnimation {
                            showSheet.toggle()
                        }
                    }
                
                VStack {
                    InputWidgetView(hint: "Category", properties: InputProperties(maxLength: 10, isSelector: true), text: .constant(""))
                        .padding([.top], 24)
                    InputWidgetView(hint: "Description", properties: InputProperties(maxLength: 10), text: .constant(""))
                        .padding([.top], 16)
                    InputWidgetView(hint: "Wallet", properties: InputProperties(maxLength: 10, isSelector: true), text: .constant(""))
                        .padding([.top, .bottom], 16)
                    HStack(alignment: .center) {
                        HStack(spacing: 10) {
                            Image.Custom.attachment
                            Text("Add Attachment")
                        }
                        .frame(maxWidth: .infinity)
                        .padding([.vertical], 16)
                        
                    }
                    
                    .background(
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6], dashPhase: phase))
                            .foregroundColor(CustomColor.baseLight_20)
                            .cornerRadius(5)
                    )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Repeat")
                                .font(.system(size: 16))
                                .foregroundColor(CustomColor.baseDark_25)
                            
                            Text("Repeat Transaction")
                                .font(.system(size: 13))
                                .foregroundColor(CustomColor.baseLight_20)
                        }
                        .padding([.leading], 16)
                        Toggle("", isOn: $isRepeated)
                        
                    }
                    .padding([.vertical], 16)
                    
                    ButtonWidgetView(title: "Continue", style: .primaryButton) {
                        
                    }
                    .padding([.bottom], geometry.safeAreaInsets.bottom + 10)
                }
                .padding([.horizontal], 16)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .background(
                    RoundedCorner(radius: 30)
                        .foregroundColor(CustomColor.baseLight)
                )
            }
            .overlay(KeyboardWidget(geometry: geometry, amount: $amount, isShowing: $showSheet), alignment: .center)
            .background(
                Rectangle()
                    .foregroundColor(getBgColor(type: newEntryType))
                
            )
            .edgesIgnoringSafeArea([.all])
            
            
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

