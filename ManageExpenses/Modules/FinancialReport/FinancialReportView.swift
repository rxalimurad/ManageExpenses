//
//  FinancialReportView.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.


import SwiftUI

struct FinancialReportView: View {
    var safeAreaInsets: EdgeInsets
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel: TransactionViewModel
    var body: some View {
        VStack {
            NavigationBar(title: "Financial Report", top: 0, titleColor: CustomColor.baseDark) {
                mode.wrappedValue.dismiss()
            }
            headerView
            PieChart(chartData: PieChartData(dataSets: PieDataSet(dataPoints: viewModel.pieChartPoints
                                                                  , legendTitle: ""), metadata: ChartMetadata()))
            .frame(height: 200)
            SegmentedControlWidgetView(items: ["\nExpense\n", "\nIncome\n"], selectedIndex: $viewModel.selectedTab, padding: 1, fontSize: 16, textColor: CustomColor.primaryColor, bgColor: CustomColor.primaryColor_20)
                .padding([.top], 25)
                .padding([.leading, .trailing], 16)
            FinancialDetailView()
            
            
        }
        .fullScreenCover(item: $viewModel.selectedTrans, content: { trans in
            TransactionDetailView(transaction: trans, updateTransaction: viewModel)
        })
        
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
                    
                } label: {
                    Image.Custom.filter
                }.hidden()
                
                
            }
            .padding([.top, .bottom], 12)
            .padding([.leading, .trailing], 16)
            
            
        }
        .cornerRadius(15)
    }
    
    @ViewBuilder func FinancialDetailView() -> some View {
        
        ScrollView(.vertical) {
            VStack {
                ForEach(viewModel.financialReportList) { financialReport in
                    FinancialReportCellView(analyingData: financialReport)
                }
            }
            .padding([.horizontal], 32)
            .padding([.vertical], 10)
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

