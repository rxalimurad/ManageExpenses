//
//  TransactionView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI

struct TransactionTabView: View {
    var safeAreaInsets: EdgeInsets
    @ObservedObject var viewModel: TransactionViewModel
    var body: some View {
        VStack {
            headerView
            subHeader
                .cornerRadius(10)
                .padding([.horizontal], 16)
            
            transactions
        }
        .fullScreenCover(item: $viewModel.selectedTrans, content: { trans in
            TransactionDetailView(transaction: trans, updateTransaction: viewModel)
        })
        .fullScreenCover(isPresented: $viewModel.isfinancialReportShowing) {
            FinancialReportView(safeAreaInsets: safeAreaInsets, viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.isDurationFilterSheetShowing) {
            ZStack (alignment: .bottom) {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModel.isDurationFilterSheetShowing.toggle()
                        viewModel.resetDurationFilters()
                    }
                durationFilterSheet()
            }
            .background(ColoredView(color: .clear))
            .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $viewModel.isfilterSheetShowing) {
            ZStack (alignment: .bottom) {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModel.resetFilters()
                        viewModel.isfilterSheetShowing.toggle()
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
                viewModel.isfinancialReportShowing.toggle()
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
            VStack {
                ForEach(viewModel.transactions, id: \.self) { transaction in
                    Button {
                        viewModel.selectedTrans = transaction
                    } label: {
                        TransactionView(transaction: transaction, showDate: true)
                    }
                }
                .skeletonForEach(itemsCount: 10) { _ in
                    TransactionView(transaction: Transaction.new)
                }
                .setSkeleton(
                    $viewModel.isLoading,
                    animationType: .solid(Color.gray.opacity(0.4)),
                    animation: Animation.default,
                    transition: AnyTransition.identity
                )
            }
        }
    }
    
    var headerView: some View {
        VStack {
            HStack(alignment: .center) {
                
                Button(action: {
                    viewModel.isDurationFilterSheetShowing.toggle()
                }, label: {
                    HStack(alignment: .center) {
                        Image.Custom.downArrow
                            .padding([.leading ], 5)
                        Text(viewModel.transDuration)
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
                    viewModel.isfilterSheetShowing.toggle()
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
                viewModel.resetFilters()
                viewModel.isfilterSheetShowing.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
                
            }
            
            
            VStack(spacing: 8) {
                TransactionFilterView(safeAreaInsets: safeAreaInsets, isfilterSheetShowing: $viewModel.isfilterSheetShowing, sortedBy: $viewModel.sortedBy, filterBy: $viewModel.filterBy, transViewModel: viewModel, categoryData: $viewModel.categoryData)
                
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
                viewModel.isDurationFilterSheetShowing.toggle()
                viewModel.resetDurationFilters()
            } label: {
                indicator
                    .padding([.top], 16)
                
            }
            VStack(spacing: 8) {
                TransactionDurationFilterView(safeAreaInsets: safeAreaInsets, isfilterSheetShowing: $viewModel.isDurationFilterSheetShowing, type: $viewModel.transDuration, dateFrom: $viewModel.dateFrom, dateTo: $viewModel.dateTo, transViewModel: viewModel)
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
        TransactionTabView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), viewModel: TransactionViewModel(dbHandler: FirestoreService()))
    }
}
