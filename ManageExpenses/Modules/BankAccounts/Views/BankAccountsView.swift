//
//  BankAccountsView.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import SwiftUI

struct BankAccountsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var selectedBank: SelectDataModel?
    @State var isAddBankShown = false
    
    @ObservedObject var viewModel = BankAccountViewModel(service: FirestoreService())
    
    var body: some View {
        VStack{
            NavigationBar(title: "Accounts", top: 0, titleColor: CustomColor.baseDark, action: {
                mode.wrappedValue.dismiss()
            })
            
            Text("Account Balance")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
                .padding([.top], 40)
            Text(Utilities.getFormattedAmount(amount: viewModel.banks.map({Double($0.balance ?? "0")!}).reduce(0, +)))
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 8)
            
            ScrollView {
                VStack {
                    ForEach(viewModel.banks) { bank in
                        
                        Button {
                            selectedBank = bank
                        } label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(bank.color)
                                    .padding([.vertical], 12)
                                Text(bank.desc)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(CustomColor.baseDark)
                                    .padding([.leading], 8)
                                Spacer()
                                Text(Utilities.getFormattedAmount(amount: Double(bank.balance ?? "0") ?? 0))
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(CustomColor.baseDark)
                                
                            }
                        }
                        
                        Divider()
                            .foregroundColor(CustomColor.baseLight_20)
                        
                    }
                }
                .padding([.top], 75)
                .padding([.horizontal], 16)
            }
            
            Spacer()
            
            ButtonWidgetView(title: "+ Add new wallet", style: .primaryButton) {
                isAddBankShown.toggle()
            }
            .padding([.horizontal], 16)
            .padding([.bottom], 16)
            
        }
        
        .fullScreenCover(item: $selectedBank, content: { bank in
            BankDetailsView(bank: $selectedBank.toUnwrapped(defaultValue: bank), viewModel: BankDetailsViewModel(bankId: bank.id, service: FirestoreService())
            )
        })
        .fullScreenCover(isPresented: $isAddBankShown) {
            AddBankAccount()
        }
        
    }
}


