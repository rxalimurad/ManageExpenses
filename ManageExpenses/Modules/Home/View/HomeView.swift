//
//  HomeView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var safeAreaInsets: EdgeInsets
    
    @State private var isRecentTransactionShowing = true
    @State private var selectedTrans: Transaction?
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                summaryView
                    .background(LinearGradient(colors: [CustomColor.bgYellow, CustomColor.bgYellow.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(28, corners: [.bottomLeft, .bottomRight])
                
                
                ScrollView {
                    VStack {
                        Text("").frame(height: 10)
                        Group {
                            Text("Spending Frequency")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(CustomColor.baseDark)
                                .padding([.top], 0)
                                .padding([.leading], 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LineChart(chartData: viewModel.lineChartData)
                                .pointMarkers(chartData: viewModel.lineChartData)
                                .touchOverlay(chartData: viewModel.lineChartData,
                                              formatter: numberFormatter)
                                .xAxisLabels(chartData: viewModel.lineChartData)
                                .yAxisLabels(chartData: viewModel.lineChartData,
                                             formatter: numberFormatter)
                            
                                .id(viewModel.lineChartData.id)
                                .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 150, maxHeight: 150, alignment: .center)
                                .padding([.trailing], 16)
                                .padding([.top], 15)
                                .isHidden(viewModel.lineChartData.dataSets.dataPoints.count < 2)
                            Text("Not enough data to show")
                                .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 150, maxHeight: 150, alignment: .center)
                                .isHidden(viewModel.lineChartData.dataSets.dataPoints.count >= 2)
                            Text(viewModel.graphXAxis[viewModel.currentFilter])
                                .foregroundColor(CustomColor.primaryColor).font(.caption)
                                .padding([.horizontal], 5)
                                .id(viewModel.currentFilter)
                        }
                        
                        VStack {
                            SegmentedControlWidgetView(
                                items: viewModel.options,
                                selectedIndex: $viewModel.currentFilter
                            ).padding([.horizontal], 10)
                            
                            HStack {
                                Text("Recent Transaction")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(CustomColor.baseDark)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Text("View All")
                                        .padding([.vertical], 7)
                                        .padding([.horizontal], 15)
                                        .font(.system(size: 14, weight:.medium))
                                        .foregroundColor(CustomColor.primaryColor)
                                        .background(CustomColor.primaryColor.opacity(0.2))
                                        .cornerRadius(16)
                                }
                                .frame(height: 32)
                                
                            }
                            .padding([.top, .leading, .trailing], 16)
                            
                            getTransactionView($viewModel.transactions)
                        }.transition(.move(edge: .bottom))
                        
                    }
                    
                }
                
            }
            .fullScreenCover(item: $selectedTrans, content: { trans in
                TransactionDetailView(transaction: trans)
            })
            
            //ViewForServiceAPI(state: $viewModel.state, bgOpacity: 0.5)
        }
    }
    
    @ViewBuilder func getTransactionView(_ transactions: Binding<[DatedTransactions]>) -> some View {
        ForEach(viewModel.transactions, id: \.self) { datedTransaction in
            Text(datedTransaction.date)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CustomColor.baseDark)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal], 19)
            
            ForEach(datedTransaction.transactions, id: \.self) { transaction in
                Button {
                    selectedTrans = transaction
                } label: {
                    TransactionView(transaction: transaction)
                }
            }
        }.skeletonForEach(itemsCount: 5) { _ in
            TransactionView(transaction: Transaction.new)
        }.setSkeleton(
            .constant(viewModel.isLoading),
            animationType: .solid(Color.gray.opacity(0.4)),
            animation: Animation.default,
            transition: AnyTransition.identity
        )
    }
    
    var summaryView: some View {
        VStack {
            HStack(alignment: .center) {
                ZStack {
                    Circle()
                        .strokeBorder(CustomColor.baseLight, lineWidth: 5)
                    Circle()
                        .strokeBorder(CustomColor.primaryColor, lineWidth: 2)
                    Image.Custom.apple
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .frame(width: 38, height: 38)
                .padding([.leading], 16)
                
                Spacer()
                VStack {
                    Text("Account Balance")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(CustomColor.baseLight_20)
                    Text(viewModel.getAccountBalance())
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(CustomColor.baseDark_75)
                }
                Spacer()
                Image.Custom.bell
                    .hidden()
                    .padding([.trailing], 21)
            }.padding([.top, .bottom], 12)
                .padding([.top], safeAreaInsets.top)
            
            
            
            HStack(spacing: 16) {
                totalIncomeView
                    .cornerRadius(28)
                    .frame(height: 80)
                totalExpensesView
                    .cornerRadius(28)
                    .frame(height: 80)
            }
            .padding([.leading, .trailing], 16)
            
            
        }.cornerRadius(15)
    }
    
    var totalIncomeView: some View {
        ZStack {
            Color.green
            HStack  {
                
                Image.Custom.inflow
                VStack(alignment: .leading) {
                    Text("Income")
                        .font(.system(size: 14, weight: .medium))
                    Text(viewModel.getIncome())
                        .font(.system(size: 22, weight: .semibold))
                }
                .foregroundColor(CustomColor.baseLight_80)
            }
        }
    }
    var totalExpensesView: some View {
        ZStack {
            Color.red
            HStack  {
                Image.Custom.outflow
                VStack(alignment: .leading) {
                    Text("Expenses")
                        .font(.system(size: 14, weight: .medium))
                    Text(viewModel.getExpense())
                        .font(.system(size: 22, weight: .semibold))
                }.foregroundColor(CustomColor.baseLight_80)
            }
        }
    }
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
}


