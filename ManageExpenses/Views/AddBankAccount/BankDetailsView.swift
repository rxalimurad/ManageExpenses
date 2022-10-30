//
//  BankDetails.swift
//  ManageExpenses
//
//  Created by murad on 31/10/2022.
//

import SwiftUI

struct BankDetailsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
        animation: .default)
    private var recentTransactions: FetchedResults<Transaction>
    @Binding var bank: SelectDataModel
    var viewModel = BankDetailsViewModel()
    @State var editBankshown = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack{
            NavigationBar(title: "Accounts", top: 0, titleColor: CustomColor.baseDark, action: {
                mode.wrappedValue.dismiss()
            }, rightBtnImage: Image.Custom.edit) {
                editBankshown.toggle()
            }
            
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 48, height: 48)
                .foregroundColor(bank.color)
                .padding([.top], 47)
            Text(bank.desc)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 8)
            Text(Utilities.getFormattedAmount("$", amount: Double(bank.balance ?? "0") ?? 0))
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 12)
            
            transactions
                .padding([.top], 30)
            
            
            Spacer()
        }
        .fullScreenCover(isPresented: $editBankshown) {
            AddBankAccount(category: $bank)
        }
    }
    var transactions: some View {
        ScrollView {
            ForEach(viewModel.getTransactionDict(transactions: recentTransactions), id: \.self) { headerTransDate in
                Text(headerTransDate)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(CustomColor.baseDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal], 19)
                ForEach(viewModel.recentTransactionsDict[headerTransDate]!, id: \.self) { transaction in
                    TransactionView(transaction: transaction)
                }
            }
            
        }
    }
}
//
//struct BankDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        BankDetailsView(bank: SelectDataModel(id: "", desc: ""))
//    }
//}
