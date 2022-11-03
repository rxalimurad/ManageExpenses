//
//  TransactionView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI

struct TransactionTabView: View {
    var safeAreaInsets: EdgeInsets
    @State var isDurationFilterSheetShowing = false
    @State var isfilterSheetShowing = false
    @State var isfinancialReportShowing = false
    @State var customDateSeleced = false
    @State var dateTo = Date()
    @State var dateFrom = Date()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
        animation: .default)
    private var recentTransactions: FetchedResults<Transaction>
    @State private var selectedTrans: Transaction?
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack {
            headerView
            subHeader
                .cornerRadius(10)
                .padding([.horizontal], 16)
            
            transactions
        }
        .fullScreenCover(item: $selectedTrans, content: { trans in
            TransactionDetailView(transaction: trans)
        })
        .fullScreenCover(isPresented: $isfinancialReportShowing) {
            FinancialReportView(safeAreaInsets: safeAreaInsets)
        }
        .fullScreenCover(isPresented: $isDurationFilterSheetShowing) {
            ZStack (alignment: .bottom) {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isfilterSheetShowing.toggle()
                    }
                durationFilterSheet()
            }
            .background(ColoredView(color: .clear))
            .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $isfilterSheetShowing) {
            ZStack (alignment: .bottom) {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isfilterSheetShowing.toggle()
                    }
                  filterSheet()
            }
            .background(ColoredView(color: .clear))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    
    
    
    var subHeader: some View {
        HStack {
            Button {
                isfinancialReportShowing.toggle()
            } label: {
                Text("See your financial report")
                    .foregroundColor(CustomColor.primaryColor)
                    .font(.system(size: 16, weight: .medium))
                    .padding([.vertical], 15)
                Spacer()
                Image.Custom.downArrow.rotationEffect(Angle(degrees: 270))
            }

            
           
        }.padding([.horizontal], 16)
            .background(CustomColor.primaryColor_20)
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
                    Button {
                        selectedTrans = transaction
                    } label: {
                        TransactionView(transaction: transaction)
                    }
                }
            }
            
        }
    }
    
    var headerView: some View {
        VStack {
            HStack(alignment: .center) {
                
                Button(action: {
                    isDurationFilterSheetShowing.toggle()
                }, label: {
                    HStack(alignment: .center) {
                        Image.Custom.downArrow
                            .padding([.leading ], 5)
                        Text("This Month")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(CustomColor.baseDark_50)
                            .padding([.top,.bottom], 11)
                            .padding([.trailing], 16)
                    }
                })
                .padding([.leading], 16)
                .overlay(RoundedRectangle(cornerRadius: 40, style: .circular)
                            .stroke(CustomColor.baseLight_60, lineWidth: 1)
                )
                
                Spacer()
                Button {
                    isfilterSheetShowing.toggle()
                } label: {
                    Image.Custom.filter
                }
                

            }.padding([.top, .bottom], 12)
                .padding([.top], safeAreaInsets.top)
            
            
                .padding([.leading, .trailing], 16)
            
            
        }
        .cornerRadius(15)
        
        
        
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
        
    private func filterSheet() ->  some View {
        VStack {
            Button {
                isfilterSheetShowing.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
                   
            }
            
            
            VStack(spacing: 8) {
                TransactionFilterView(safeAreaInsets: safeAreaInsets, isfilterSheetShowing: $isfilterSheetShowing)
            }
            .padding([.top], 22)
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + safeAreaInsets.bottom)
            
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .edgesIgnoringSafeArea([.all])
    }
    
    private func durationFilterSheet() ->  some View {
        VStack {
            Button {
                isfilterSheetShowing.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
                   
            }
            
            
            VStack(spacing: 8) {
                TransactionDurationFilterView(safeAreaInsets: safeAreaInsets, isfilterSheetShowing: $isDurationFilterSheetShowing, dateFrom: $dateFrom, dateTo: $dateTo)
            }
            .padding([.top], 22)
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + safeAreaInsets.bottom)
            
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .edgesIgnoringSafeArea([.all])
    }
    
}


struct TransactionTabView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionTabView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
