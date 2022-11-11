//
//  AddBankAccount.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import SwiftUI
import AlertX

struct AddBankAccount: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // Mark: - View Model
    @ObservedObject var viewModel = AddBankAccountViewModel(service: FirestoreBankService())
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                NavigationBar(title: "Add Account", top: geometry.safeAreaInsets.top) {
                    mode.wrappedValue.dismiss()
                }
                
                Text("Balance")
                    .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                    .font(.system(size: 18, weight: .medium))
                    .padding([.leading], 26)
                AmountInputWidget(amount: viewModel.bank.balance ?? "0")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(CustomColor.baseLight)
                    .padding([.top], 13)
                    .onTapGesture {
                        withAnimation {
                            viewModel.showAmtKeybd.toggle()
                        }
                    }
                
                Spacer()
            }
            .overlay(getAddDetailsView(geometry),alignment: .bottom)
            .overlay(KeyboardWidget(geometry: geometry, amount: $viewModel.bank.balance.toUnwrapped(defaultValue: "0"), isShowing: $viewModel.showAmtKeybd), alignment: .center)
            .background(
                Rectangle()
                    .foregroundColor(CustomColor.primaryColor)
                
            )
            .edgesIgnoringSafeArea([.all])
            
        }
    }
    
    @ViewBuilder private func getAddDetailsView(_ geometry: GeometryProxy) -> some View {
        VStack {
          
            InputWidgetView(hint: "Bank Name", properties: InputProperties(maxLength: 10), text: $viewModel.bank.desc, isValidField: .constant(true))
                .padding([.top],24)
                .padding([.horizontal], 16)
            ColorPicker("Set the bank color", selection: $viewModel.bank.color)
                .padding([.top],16)
                .padding([.horizontal], 16)
            
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                viewModel.addBankAccount()
                viewModel.isBankAdded.toggle()
               
            }
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            .alertX(isPresented: $viewModel.isBankAdded, content: {
                AlertX(title: Text("Bank has been successfully added"),  buttonStack: [AlertX.Button.default(Text("OK"), action: {
                    mode.wrappedValue.dismiss()
                })], theme: .custom(windowColor: CustomColor.baseLight, alertTextColor: CustomColor.baseDark  , enableShadow: true, enableRoundedCorners: true, enableTransparency: false, cancelButtonColor: .white, cancelButtonTextColor: .white, defaultButtonColor: CustomColor.primaryColor, defaultButtonTextColor: CustomColor.baseLight), animation: AlertX.AnimationX.classicEffect())
            })
        }
        .padding([.horizontal], 16)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .background(
            RoundedCorner(radius: 30)
                .foregroundColor(CustomColor.baseLight)
        )
        
    }

    
    
}

//struct AddBankAccount_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBankAccount(, category: <#Binding<SelectDataModel>#>)
//    }
//}
