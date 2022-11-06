//
//  BankAccountsView.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import SwiftUI

struct BankAccountsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var walletData = [SelectDataModel(id: "1", desc: "Pay Pal", balance: "23.3",color: .red),
                             SelectDataModel(id: "2", desc: "Bank Al Habib", balance: "32.3", color: .green),
                             SelectDataModel(id: "3", desc: "SadaaPay", balance: "23.3",color: .yellow)]
    @State var selectedBank: SelectDataModel?
    @State var isAddBankShown = false
    
    var body: some View {
        VStack{
            NavigationBar(title: "Accounts", top: 0, titleColor: CustomColor.baseDark, action: {
                mode.wrappedValue.dismiss()
            })
            
            Text("Account Balance")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
                .padding([.top], 40)
            Text(Utilities.getFormattedAmount(amount: walletData.map({Double($0.balance ?? "0")!}).reduce(0, +)))
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 8)
            
            ScrollView {
                VStack {
                    ForEach(0 ..< walletData.count) {index in
                        Button {
                            selectedBank = walletData[index]
                        } label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(walletData[index].color)
                                    .padding([.vertical], 12)
                                Text(walletData[index].desc)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(CustomColor.baseDark)
                                    .padding([.leading], 8)
                                Spacer()
                                Text(Utilities.getFormattedAmount(amount: Double(walletData[index].balance ?? "0") ?? 0))
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
            BankDetailsView(bank: $selectedBank.toUnwrapped(defaultValue: bank))
        })
        .fullScreenCover(isPresented: $isAddBankShown) {
            AddBankAccount(category: .constant(SelectDataModel(id: "", desc: "", balance: "0", Image: nil, color: .black, isSelected: false)))
        }
        
        
        
        
    }
    }
    
    struct BankAccountsView_Previews: PreviewProvider {
        static var previews: some View {
            BankAccountsView()
        }
    }
