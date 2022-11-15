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
    @ObservedObject var viewModel = AddBankAccountViewModel(service: FirestoreService())
    weak var delegate: UpdateTransaction?
    var isFirstBank = false
    @State var isFirstBankState = false
    @State var isBankNameValid = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    NavigationBar(title: "Add Account", top: geometry.safeAreaInsets.top, showBackBtn: !isFirstBank) {
                        mode.wrappedValue.dismiss()
                    }
                    if isFirstBankState {
                        Text("Let's setup your account by adding a Bank Acount")
                            .foregroundColor(CustomColor.baseLight_80)
                            .font(.system(size: 40, weight: .medium))
                            .padding([.leading], 26)
                            .padding([.bottom], 40)
                            .transition(.scale)
                    }
                    Text("Balance")
                        .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                        .font(.system(size: 18, weight: .medium))
                        .padding([.leading], 26)
                    AmountInputWidget(amount: viewModel.bank.balance ?? "")
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
                .overlay(KeyboardWidget(geometry: geometry, amount: $viewModel.bank.balance.toUnwrapped(defaultValue: ""), isShowing: $viewModel.showAmtKeybd), alignment: .center)
                .background(
                    Rectangle()
                        .foregroundColor(CustomColor.primaryColor)
                    
                )
                .edgesIgnoringSafeArea([.all])
                ViewForServiceAPI(state: $viewModel.state)
            }
            
        }
        .onAppear() {
            withAnimation {
                isFirstBankState = isFirstBank
            }
        }
    }
    
    @ViewBuilder private func getAddDetailsView(_ geometry: GeometryProxy) -> some View {
        VStack {
            
            InputWidgetView(hint: "Bank Name", properties: InputProperties(maxLength: 20, minLength: 3), text: $viewModel.bank.desc, isValidField: $isBankNameValid)
                .padding([.top],24)
                .padding([.horizontal], 16)
            ColorPicker("Set the bank color", selection: $viewModel.bank.color)
                .padding([.top],16)
                .padding([.horizontal], 16)
            
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                viewModel.addBankAccount() { success in
                    if success {
                        viewModel.isBankAdded.toggle()
                    }
                }
            }
            .disabled(!validate())
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            .alertX(isPresented: $viewModel.isBankAdded, content: {
                AlertX(title: Text("Bank has been successfully added"),  buttonStack: [AlertX.Button.default(Text("OK"), action: {
                    delegate?.refresh()
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
    
    private func validate() -> Bool {
        isBankNameValid && viewModel.bank.balance != nil &&
        Double(viewModel.bank.balance ?? "0") != 0.0
    }
    
    
}
