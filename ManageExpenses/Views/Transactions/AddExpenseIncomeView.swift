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
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = AddExpenseIncomeViewModel()
    
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
    @State var categoryData = [SelectDataModel(id: "1", desc: "Food", Image: .Custom.camera, color: .red),
                               SelectDataModel(id: "2", desc: "Fuel", Image: .Custom.bell, color: .green),
                               SelectDataModel(id: "3", desc: "Shopping", Image: .Custom.bell, color: .yellow),
                               SelectDataModel(id: "4", desc: "Clothes", Image: .Custom.bell, color: .blue),
                               SelectDataModel(id: "5", desc: "Fee", Image: .Custom.bell, color: .black)]
    
    @State var walletData = [SelectDataModel(id: "1", desc: "Pay Pal", balance: "23.3",color: .red),
                             SelectDataModel(id: "2", desc: "Bank Al Habib", balance: "32.3", color: .green),
                             SelectDataModel(id: "3", desc: "SadaaPay", balance: "23.3",color: .yellow),
    ]
    
    
    var newEntryType: PlusMenuAction
    var body: some View {
        GeometryReader { geometry in
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
            .fullScreenCover(isPresented: $isAtchmntViewShown) {
                ZStack (alignment: .bottom) {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isAtchmntViewShown.toggle()
                        }
                    attachmentSheet(geometry)
                }
                .background(ColoredView(color: .clear))
                .edgesIgnoringSafeArea(.all)
            }
            
            .background(
                Rectangle()
                    .foregroundColor(getBgColor(type: newEntryType))
                
            )
            .sheet(isPresented: $isImgPkrShown, content: {
                ImagePicker(image: $selectedImage, type: .photoLibrary)
            })
            .sheet(isPresented: $isCamerPkrShown, content: {
                ImagePicker(image: $selectedImage, type: .camera)
            })
            .edgesIgnoringSafeArea([.all])
            
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
                    SelectorWidgetView(hint: "From", text: $fromWallet, data: $categoryData)
                    
                    SelectorWidgetView(hint: "To", text: $toWallet, data: $categoryData)
                    
                }
                Image.Custom.transferSign
            }
            
            .padding([.top], 24)
            InputWidgetView(hint: "Description", properties: InputProperties(maxLength: 225), text: $description)
                .padding([.top], 16)
                .padding([.top, .bottom], 16)
            if selectedImage == nil {
                HStack(alignment: .center) {
                    HStack(spacing: 10) {
                        Image.Custom.attachment
                        Text("Add Attachment")
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.vertical], 16)
                    
                }.onTapGesture {
                    withAnimation {
                        isAtchmntViewShown.toggle()
                    }
                }.background(
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6], dashPhase: phase))
                        .foregroundColor(CustomColor.baseLight_20)
                        .cornerRadius(5)
                )
            } else {
                HStack {
                    ZStack(alignment: .topTrailing) {
                        selectedImage?
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        Button {
                            withAnimation {
                                selectedImage = nil
                            }
                        } label: {
                            Image.Custom.grayCross
                                .resizable()
                                .frame(width: 24, height: 24)
                                .offset(x: 12, y: -12)
                        }
                        
                        
                    }
                    Spacer()
                }
            }
            
            
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                isTransactionAdded.toggle()
            }
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            .alertX(isPresented: $isTransactionAdded, content: {
                AlertX(title: Text("Transaction has been successfully added"),  buttonStack: [AlertX.Button.default(Text("OK"), action: {
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
    
    private func validateExpenseIncomeForm() -> Bool {
        return !(amount.isEmpty || category.desc.isEmpty || description.isEmpty || wallet.desc.isEmpty)
    }
    
    
    @ViewBuilder private func addDetailsViewExpenseIncome(_ geometry: GeometryProxy) -> some View {
        VStack {
            SelectorWidgetView(hint: "Category", text: $category, data: $categoryData)
                .padding([.top], 24)
            BudgetViewCell(budget: BudgetDetail(category: category, limit: 20000))
                .padding([.top], 16)
                .isShowing(category.desc.lowercased() == "shopping")
            InputWidgetView(hint: "Description", properties: InputProperties(maxLength: 10), text: $description)
                .padding([.top], 16)
            SelectorWidgetView(hint: "Wallet", text: $wallet , data: $walletData)
                .padding([.top, .bottom], 16)
            if selectedImage == nil {
                HStack(alignment: .center) {
                    HStack(spacing: 10) {
                        Image.Custom.attachment
                        Text("Add Attachment")
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.vertical], 16)
                    
                }.onTapGesture {
                    withAnimation {
                        isAtchmntViewShown.toggle()
                    }
                }.background(
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6], dashPhase: phase))
                        .foregroundColor(CustomColor.baseLight_20)
                        .cornerRadius(5)
                )
            } else {
                HStack {
                    ZStack(alignment: .topTrailing) {
                        selectedImage?
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        Button {
                            withAnimation {
                                selectedImage = nil
                            }
                        } label: {
                            Image.Custom.grayCross
                                .resizable()
                                .frame(width: 24, height: 24)
                                .offset(x: 12, y: -12)
                        }
                        
                        
                    }
                    Spacer()
                }
            }
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                isTransactionAdded.toggle()
                viewModel.saveTransaction(context: viewContext, amount: amount, name: category.desc, desc: description, type: newEntryType.rawValue, category: category.desc, wallet: wallet.desc, image: selectedImage)
            }
            
            
            .disabled(!validateExpenseIncomeForm())
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            .alertX(isPresented: $isTransactionAdded, content: {
                AlertX(title: Text("Transaction has been successfully added"),  buttonStack: [AlertX.Button.default(Text("OK"), action: {
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
    private func attachmentSheet(_ geometry: GeometryProxy) ->  some View {
        VStack {
            Button {
                isAtchmntViewShown.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
                    .padding([.bottom], 48)
            }
            
            
            HStack(spacing: 8) {
                AttachmentView(image: .Custom.camera, title: "Camera") {
                    isAtchmntViewShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.isCamerPkrShown.toggle()
                    }
                }
                AttachmentView(image: .Custom.gallery, title: "Image") {
                    isAtchmntViewShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.isImgPkrShown.toggle()
                    }
                }
                
            }
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + geometry.safeAreaInsets.bottom)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
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

