//
//  AddExpenseIncomeView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI
import AlertX

struct AddExpenseIncomeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel = AddExpenseIncomeViewModel(service: FirestoreService())
    
    // Mark: - State Variables for User Input
    @State var amount = ""
    @State var category = SelectDataModel(id: "", desc: "")
    @State var description = ""
    @State var wallet = SelectDataModel(id: "", desc: "")
    @State var toWallet = SelectDataModel(id: "", desc: "")
    @State var fromWallet = SelectDataModel(id: "", desc: "")
    @State var selectedImage: Image?
    
    @State var showAmtKeybd = false
    @State var isRepeated = false
    @State var isAtchmntViewShown = false
    
    
    @State var isImgPkrShown = false
    @State var isCamerPkrShown = false
    @State var isCategoryshown = false
    @State var isTransactionAdded = false
    @State private var phase = 0.0
    
    @State var walletData = DataCache.shared.banks
    
    var newEntryType: PlusMenuAction
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    NavigationBar(title: getTitle(type: newEntryType), top: geometry.safeAreaInsets.top) {
                        mode.wrappedValue.dismiss()
                    }
                    
                    Text("How much?")
                        .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                        .font(.system(size: 18, weight: .medium))
                        .padding([.leading], 26)
                    AmountInputWidget(amount: amount)
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(CustomColor.baseLight)
                        .padding([.top], 13)
                        .onTapGesture {
                            withAnimation {
                                showAmtKeybd.toggle()
                            }
                        }
                    
                    Spacer()
                }
                .overlay(getAddDetailsView(type: newEntryType, geometry),alignment: .bottom)
                .overlay(KeyboardWidget(geometry: geometry, amount: $amount, isShowing: $showAmtKeybd), alignment: .center)
                .background(
                    Rectangle()
                        .foregroundColor(getBgColor(type: newEntryType))
                    
                )
                
                .edgesIgnoringSafeArea([.all])
                ViewForServiceAPI(state: $viewModel.serviceStatus)
            }
            .sheet(isPresented: $isImgPkrShown, content: {
                ImagePicker(image: $selectedImage, type: .photoLibrary)
            })
            .sheet(isPresented: $isCamerPkrShown, content: {
                ImagePicker(image: $selectedImage, type: .camera)
            })
            
        }
    }
    
    @ViewBuilder private func getAddDetailsView(type: PlusMenuAction, _ geometry: GeometryProxy)  -> some View {
        if type == .convert {
            addDetailsViewTransfer(geometry)
        } else {
            addDetailsViewExpenseIncome(geometry)
        }
    }
    
    @ViewBuilder private func addDetailsViewTransfer(_ geometry: GeometryProxy) -> some View {
        VStack {
            
            ZStack(alignment: .center) {
                HStack(alignment: .center, spacing: 16) {
                    SelectorWidgetView(hint: "From", text: $fromWallet, data: $viewModel.fromWallet)
                    
                    SelectorWidgetView(hint: "To", text: $toWallet, data: $viewModel.toWallet)
                    
                }
                Image.Custom.transferSign
            }
            
            .padding([.top], 24)
            InputWidgetView(hint: "Description", properties: InputProperties(maxLength: 225), text: $description, isValidField: .constant(true))
                .padding([.top], 16)
                .padding([.top, .bottom], 16)

            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                UIApplication.shared.endEditing()
                viewModel.transfer(transaction: Transaction(
                    id: "\(UUID())",
                    amount: (Double(amount) ?? 0.0),
                    category: category.desc,
                    desc: description,
                    name: category.desc,
                    wallet: wallet.desc,
                    attachment: "",
                    type: newEntryType.rawValue,
                    fromAcc: fromWallet.desc,
                    toAcc: toWallet.desc,
                    date: Date().secondsSince1970
                ))
                {
                    self.isTransactionAdded.toggle()
            }
            }
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            .alertX(isPresented: $isTransactionAdded, content: {
                AlertView(title: "Transaction has been successfully added").show() {
                    mode.wrappedValue.dismiss()
                }
            })
        }
        .padding([.horizontal], 16)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .background(
            RoundedCorner(radius: 30)
                .foregroundColor(CustomColor.baseLight)
        )
        
    }
    
    private func validateExpenseIncomeForm() -> Bool {
        return !(amount.isEmpty || category.desc.isEmpty || description.isEmpty || wallet.desc.isEmpty)
    }
    
    //,,.. move to vm
    
    func isBudgetExist(category: String) -> Bool {
        if newEntryType == .expense {
            return DataCache.shared.budget.contains(where: {$0.category.desc.lowercased() == category})
        } else {
            return false
        }
    }
    func getBudget(category: String) -> BudgetDetail {
        return DataCache.shared.budget.filter({$0.category.desc.lowercased() == category}).first ?? BudgetDetail.getEmptyBudget()
    }
    
    
    
    @ViewBuilder private func addDetailsViewExpenseIncome(_ geometry: GeometryProxy) -> some View {
        VStack {
            SelectorWidgetView(hint: "Category", text: $category, data: $viewModel.categoryData)
                .padding([.top], 24)
            BudgetViewCell(vm: BudgetCellVM(budget: getBudget(category: category.desc.lowercased())))
                .padding([.top], 16)
                .isShowing(isBudgetExist(category: category.desc.lowercased()))
            InputWidgetView(hint: "Description", properties: InputProperties(maxLength: 225), text: $description, isValidField: .constant(true))
                .padding([.top], 16)
            SelectorWidgetView(hint: "Wallet", text: $wallet , data: $walletData)
                .padding([.top, .bottom], 16)
           
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                UIApplication.shared.endEditing()
                viewModel.saveTransaction(transaction:
                                            Transaction(
                                                id: "\(UUID())",
                                                amount: newEntryType == .expense ? -(Double(amount) ?? 0.0) : (Double(amount) ?? 0.0),
                                                category: category.desc,
                                                desc: description,
                                                name: category.desc,
                                                wallet: wallet.id,
                                                attachment: "",
                                                type: newEntryType.rawValue,
                                                fromAcc: "",
                                                toAcc: "",
                                                date: Date().secondsSince1970
                                            )
                ) {
                    self.isTransactionAdded.toggle()
                }
                
                
                
            }
            
            
            .disabled(!validateExpenseIncomeForm())
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            .alertX(isPresented: $isTransactionAdded, content: {
                AlertView(title: "Transaction has been successfully added").show() {
                    mode.wrappedValue.dismiss()
                }
            })
        }
        .padding([.horizontal], 16)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .background(
            RoundedCorner(radius: 30)
                .foregroundColor(CustomColor.baseLight)
        )
        
    }
    
    
    private var indicator: some View {
        Rectangle()
            .foregroundColor(CustomColor.primaryColor)
            .cornerRadius(Constants.bottomSheet.radius)
            .frame(
                width: Constants.bottomSheet.indicatorWidth,
                height: Constants.bottomSheet.indicatorHeight
            )
    }
    
    func getTitle(type: PlusMenuAction) -> String {
        switch type {
        case .income:
            return  "Income"
        case .expense:
            return  "Expense"
        case .convert:
            return  "Transfer"
        case .all:
            return ""
        }
    }
    func getBgColor(type: PlusMenuAction) -> Color {
        switch type {
        case .income:
            return  CustomColor.green
        case .expense:
            return  CustomColor.red
        case .all:
            return .black
        case .convert:
            return  CustomColor.blue
        }
    }
    
    
}

