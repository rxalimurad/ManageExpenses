//
//  HomeView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
        animation: .default)
    private var recentTransactions: FetchedResults<Transaction>
    var safeAreaInsets: EdgeInsets
    var data = getChartData()
    @State private var isGraphShowing = true
    @State private var isRecentTransactionShowing = true
    @State private var options = ["Day","Week","Month", "Year"]
    @State private var selectedIndex = 1
    @State private var selectedTrans: Transaction?

    var body: some View {
        VStack(alignment: .center) {
            summaryView
                .background(LinearGradient(colors: [CustomColor.bgYellow, CustomColor.bgYellow.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                .cornerRadius(28, corners: [.bottomLeft, .bottomRight])

           
            ScrollView {
                VStack {
                    Text("").frame(height: 10)
                    Text("Spending Frequency")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(CustomColor.baseDark)
                        .padding([.top], 0)
                        .padding([.leading], 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .isShowing(isGraphShowing)
                    LineChart(chartData: data)
                        .pointMarkers(chartData: data)
                        .touchOverlay(chartData: data,
                                      formatter: numberFormatter)
                        .xAxisLabels(chartData: data)
                        .yAxisLabels(chartData: data,
                                     formatter: numberFormatter)
                    
                        .id(data.id)
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 150, maxHeight: 150, alignment: .center)
                        .padding([.trailing], 16)
                        .padding([.top], 15)
                        .isShowing(isGraphShowing)
                    
                    Text("Weeks").foregroundColor(CustomColor.primaryColor).font(.caption)
                        .padding([.horizontal], 5)
                        .isShowing(isGraphShowing)
                    
                    VStack {
                        SegmentedControlWidgetView(
                            items: options,
                            selectedIndex: $selectedIndex
                        ).padding([.horizontal], 10)
                        
                        HStack {
                            Text("Recent Transaction")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(CustomColor.baseDark)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            ButtonWidgetView(title: "View All", style: .secondaryButtonSmall) {
                                
                            }.frame(width: 78, height: 32)
                        }
                        .padding([.top, .leading, .trailing], 16)
                        
                        ForEach(recentTransactions, id: \.self) { trans in
                            Button {
                                selectedTrans = trans
                            } label: {
                                TransactionView(transaction: trans)
                            }
                        }
                        
//                        ForEach(viewModel.recentTransactionsKeys, id: \.self) { headerTransDate in
//                            Text(headerTransDate)
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(CustomColor.baseDark)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding([.horizontal], 19)
//                            ForEach(viewModel.recentTransactionsDict[headerTransDate]!, id: \.self) { transaction in
//                                Button {
//                                    selectedTrans = transaction
//                                } label: {
//                                    TransactionView(transaction: transaction)
//                                }
//                            }
//                        }
                    }.transition(.move(edge: .bottom))

}
                
            }

        }
        .fullScreenCover(item: $selectedTrans, content: { trans in
            TransactionDetailView(transaction: trans)
        })
        
        
        .onAppear(){
            viewModel.getTransactionDict(transactions: recentTransactions)
        }
        .onDisappear() {
            viewModel.getTransactionDict(transactions: recentTransactions)
        }
        
        
    }
    
    
    
    
    
    var summaryView: some View {
        VStack {
            HStack(alignment: .center) {
                ZStack {
                    Circle()
                        .strokeBorder(CustomColor.baseLight, lineWidth: 5)
                    Circle()
                        .strokeBorder(CustomColor.primaryColor, lineWidth: 2)
                    Image.Custom.google
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
                    Text("$9,400")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(CustomColor.baseDark_75)
                }
                Spacer()
                Image.Custom.bell
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
                    Text("$5000")
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
                    Text("$50")
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
    
    
    static func getChartData() -> LineChartData {
        let data = LineDataSet(
            dataPoints: [
                LineChartDataPoint(value: 500, xAxisLabel: "1", description: "Monday"),
                LineChartDataPoint(value: 1000, xAxisLabel: "2", description: "Tuesday"),
                LineChartDataPoint(value: 700 , xAxisLabel: "3", description: "Wednesday"),
                LineChartDataPoint(value: 800, xAxisLabel: "4", description: "Thursday"),
                
            ],
            pointStyle: PointStyle(pointSize: 12, borderColour:.yellow, fillColour: .red, lineWidth: 10, pointType: .filled, pointShape: .circle),
            style: LineStyle(lineColour: ColourStyle(colour: CustomColor.primaryColor), lineType: .curvedLine, strokeStyle: Stroke(lineWidth: 8)))
        
        
        let chartStyle = LineChartStyle(
            markerType: LineMarkerType.full(attachment: MarkerAttachment.point,
                                            colour: CustomColor.primaryColor),
            xAxisLabelColour: CustomColor.primaryColor,
            xAxisBorderColour: CustomColor.primaryColor,
            yAxisLabelPosition: .leading,
            yAxisLabelColour: CustomColor.primaryColor,
            yAxisNumberOfLabels: 5,
            yAxisLabelType: .numeric,
            yAxisTitle: "",
            yAxisTitleColour: .black)
        return LineChartData(dataSets: data, chartStyle: chartStyle)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(safeAreaInsets: EdgeInsets())
    }
}

