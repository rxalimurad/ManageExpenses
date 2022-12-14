//
//  TransactionDetailView.swift
//  ManageExpenses
//
//  Created by murad on 23/10/2022.
//

import SwiftUI

protocol UpdateTransaction: AnyObject {
    func deleteTransaction(transaction: Transaction, completion: @escaping((Bool) -> Void))
    func refresh()
}

struct TransactionDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var transaction: Transaction
    @State var state = ServiceAPIState.na
    var updateTransaction: UpdateTransaction
    @State var attachmentImage = Image("")
    @State var showDeleteDialog = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    VStack(alignment: .center) {
                        NavigationBar(title: "Detail Transaction", top: geometry.safeAreaInsets.top, showRightBtn: TransactionCategory(rawValue: transaction.category) != .transfer, action: {
                            mode.wrappedValue.dismiss()
                        }, rightBtnImage: .Custom.delete) {
                            self.showDeleteDialog.toggle()
                        }
                        AmountInputWidget(amount: "\(transaction.amount)", leading: 0)
                            .font(.system(size: 64, weight: .medium))
                            .foregroundColor(CustomColor.baseLight)
                            .padding([.top], 26)
                        
                        
                        Text(transaction.name)
                            .foregroundColor(CustomColor.baseLight_80)
                            .font(.system(size: 16, weight: .medium))
                            .padding([.top], 0)

                        Text(transaction.date.dateToShow)
                            .foregroundColor(CustomColor.baseLight_80)
                            .font(.system(size: 13, weight: .medium))
                            .padding([.top], 8)
                            .padding([.bottom], 51)
                        
                    }.background(
                        Rectangle()
                            .foregroundColor(getBgColor(type: PlusMenuAction(rawValue: transaction.type) ?? .convert))
                        
                    ).cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                    
                    
                    HStack(alignment: .center) {
                        VStack(spacing: 9) {
                            Text("Type")
                                .foregroundColor(CustomColor.baseLight_20)
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(transaction.type.capitalized)
                                .foregroundColor(CustomColor.baseDark)
                                .font(.system(size: 16, weight: .semibold))
                        }.padding([.vertical], 12)
                            .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 9) {
                            Text("Category")
                                .foregroundColor(CustomColor.baseLight_20)
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(transaction.category)
                                .foregroundColor(CustomColor.baseDark)
                                .font(.system(size: 16, weight: .semibold))
                        }.padding([.vertical], 12)
                            .frame(maxWidth: .infinity)
                        VStack(spacing: 9) {
                            Text("Wallet")
                                .foregroundColor(CustomColor.baseLight_20)
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(Utilities.getBankName(bankId: transaction.wallet))
                                .foregroundColor(CustomColor.baseDark)
                                .font(.system(size: 16, weight: .semibold))
                        }.padding([.vertical], 12)
                            .frame(maxWidth: .infinity)
                    }
                    
                    .background(ColoredView(color: .white))
                    .cornerRadius(16)
                    .overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(CustomColor.baseLight_60))
                    .padding([.horizontal], 16)
                    
                    .offset(x: 0, y: -35)
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            Text("Description")
                                .foregroundColor(CustomColor.baseLight_20)
                                .font(.system(size: 16, weight: .medium))
                                .padding([.horizontal], 16)
                                .padding([.top], 14)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(transaction.desc)
                                .foregroundColor(CustomColor.baseDark)
                                .font(.system(size: 16, weight: .medium))
                                .padding([.horizontal], 16)
                                .padding([.top], 15)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                        }
                    }
                    .offset(x: 0, y: -35)
                    Spacer()
                    
//                    ButtonWidgetView(title: "Edit", style: .primaryButton) {
//
//                    }
                    .padding([.horizontal], 16)
                    .padding([.bottom], geometry.safeAreaInsets.bottom + 20)
                    
                }
                ViewForServiceAPI(state: self.$state)
            }

                .fullScreenCover(isPresented: $showDeleteDialog) {
                    ZStack (alignment: .bottom) {
                        Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showDeleteDialog.toggle()
                            }
                        deleteSheet(geometry.safeAreaInsets)
                    }
                    .background(ColoredView(color: .clear))
                    .edgesIgnoringSafeArea(.all)
                }
                
                .edgesIgnoringSafeArea([.all])
                .onAppear() {
                    DispatchQueue.global(qos: .background).async {
//                        attachmentImage = Image.getImage(data: transaction.image)
                    }
                }
            
            
            
            
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
        case .all:
                return .black
        }
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
    private func deleteSheet(_ safeAreaInsets: EdgeInsets) ->  some View {
        VStack {
            Button {
                showDeleteDialog.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
            }

            Text("Delete?")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 20)
            Text("Are you sure do you wanna delete this transaction?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
                .padding([.horizontal], 16)
                .padding([.top], 20)
            
            HStack(spacing: 16) {
                ButtonWidgetView(title: "No", style: .secondaryButton) {
                    showDeleteDialog.toggle()
                }
                ButtonWidgetView(title: "Yes", style: .primaryButton) {
                    self.state = .inprogress
                    updateTransaction.deleteTransaction(transaction: transaction) { success in
                        if success {
                            self.state = .successful
                            showDeleteDialog.toggle()
                            mode.wrappedValue.dismiss()
                        } else {
                            self.state = .failed(error: NetworkingError("Some error occured"))
                        }

                    }
                }
                
            }
            .padding([.top], 16)
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + safeAreaInsets.top)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
    }
    
}
