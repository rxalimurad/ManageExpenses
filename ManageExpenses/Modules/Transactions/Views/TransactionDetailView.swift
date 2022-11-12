//
//  TransactionDetailView.swift
//  ManageExpenses
//
//  Created by murad on 23/10/2022.
//

import SwiftUI

protocol DeleteTransaction {
    func deleteTransaction(id: String, completion: @escaping((Bool) -> Void))
    func refresh()
}

struct TransactionDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var transaction: Transaction
    var viewModel: DeleteTransaction
    @State var attachmentImage = Image("")
    var body: some View {
        GeometryReader { geometry in
                VStack {
                    VStack(alignment: .center) {
                        NavigationBar(title: "Detail Transaction", top: geometry.safeAreaInsets.top, action: {
                            mode.wrappedValue.dismiss()
                        }, rightBtnImage: .Custom.delete) {
                            viewModel.deleteTransaction(id: transaction.id) { success in
                                if success {
                                    viewModel.refresh()
                                    mode.wrappedValue.dismiss()
                                }
                                
                            }
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
                            .foregroundColor(getBgColor(type: PlusMenuAction(rawValue: transaction.type) ?? .expense))
                        
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
                            
                            Text("Bank")
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
                    
                    ButtonWidgetView(title: "Edit", style: .primaryButton) {
                        
                    }
                    .padding([.horizontal], 16)
                    .padding([.bottom], geometry.safeAreaInsets.bottom + 20)
                    
                }.edgesIgnoringSafeArea([.all])
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
    
    
}
