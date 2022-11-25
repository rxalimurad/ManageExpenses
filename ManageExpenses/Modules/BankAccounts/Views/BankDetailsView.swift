//
//  BankDetails.swift
//  ManageExpenses
//
//  Created by murad on 31/10/2022.
//

import SwiftUI

struct BankDetailsView: View {
//    private var recentTransactions: FetchedResults<Transaction>
    @Binding var bank: SelectDataModel
    var viewModel: BankDetailsViewModel
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
            Text(Utilities.getFormattedAmount(amount: Double(bank.balance ?? "0") ?? 0))
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 12)
            
            transactions
                .padding([.top], 30)
            
            
            Spacer()
        }
        .fullScreenCover(isPresented: $editBankshown) {
            AddBankAccount(viewModel: AddBankAccountViewModel(service: FirestoreService(), bank: bank))
        }
    }
    var transactions: some View {
        ScrollView {
            ForEach(viewModel.transaction, id: \.self) { tran in
                TransactionView(transaction: tran, showDate: true)
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
