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
                    .padding([.top], 80) //,,..
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
                        .padding([.top], 16)
                    HStack {
                        Image.Custom.attachment
                        Text("Add Attachment")
                        
                    }.background(
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6], dashPhase: phase))
                            .onAppear {
                                withAnimation(.linear.repeatForever(autoreverses: false)) {
                                    phase -= 20
                                }
                            }
                        
                    )
                    
                    HStack {
                        VStack {
                            Text("Repeat")
                            Text("Repeat Transaction")
                        }
                        Toggle("", isOn: $isRepeated)
                        
                    }
                    
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

