//
//  HomeView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct HomeView: View {
    var safeAreaInsets: EdgeInsets
    var data = getChartData()
    
    init(safeAreaInsets: EdgeInsets) {
        self.safeAreaInsets = safeAreaInsets
    }
    
    @State private var options = ["Day","Week","Month", "year"]
    @State private var selectedIndex = 1
    var body: some View {
        VStack(alignment: .center) {
            summaryView
                .background(LinearGradient(colors: [CustomColor.bgYellow, CustomColor.bgYellow.opacity(0.2)], startPoint: .top, endPoint: .bottom))
            
                .cornerRadius(28, corners: [.bottomLeft, .bottomRight])
            
            ScrollView {
                VStack {
                Text("Spend Frequency")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(CustomColor.baseDark)
                    .padding([.top], 13)
                    .padding([.leading], 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LineChart(chartData: data)
                    .pointMarkers(chartData: data)
                    .touchOverlay(chartData: data,
                                  formatter: numberFormatter)
                    .xAxisLabels(chartData: data)
                    .yAxisLabels(chartData: data,
                                 formatter: numberFormatter)

                    .id(data.id)
                    .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 300, alignment: .center)
                    .padding([.trailing], 16)
                    .padding([.top], 29)
                
                Text("Weeks").foregroundColor(CustomColor.primaryColor).font(.caption)
                    .padding([.horizontal], 5)
                Picker("Numbers", selection: $selectedIndex) {
                    ForEach(0 ..< options.count) { index in
                        Text(self.options[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
//            Spacer()
            
            
        }
        ScrollView {
            
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
                
                HStack(alignment: .center) {
                    Image.Custom.downArrow
                        .padding([.leading ], 13)
                    Text("This Month")
                        .font(.system(size: 14, weight: .medium))
                        .padding([.top,.bottom], 11)
                        .padding([.trailing], 16)
                }
                .overlay(RoundedRectangle(cornerRadius: 40, style: .circular)
                            .stroke(CustomColor.baseLight_60, lineWidth: 1)
                )
                
                Spacer()
                Image.Custom.bell
                    .padding([.trailing], 21)
            }.padding([.top, .bottom], 12)
                .padding([.top], safeAreaInsets.top)
            
            Text("Account Balance")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
            Text("$9,400")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(CustomColor.baseDark_75)
            
            HStack(spacing: 16) {
                totalIncomeView
                    .cornerRadius(28)
                    .frame(height: 80)
                totalExpensesView
                    .cornerRadius(28)
                    .frame(height: 80)
            }
            .padding([.leading, .trailing], 16)
            .padding([.bottom], 23)
            
            
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
                LineChartDataPoint(value: 10, xAxisLabel: "2", description: "Tuesday"),
                LineChartDataPoint(value: 2 , xAxisLabel: "3", description: "Wednesday"),
                LineChartDataPoint(value: 10, xAxisLabel: "4", description: "Thursday"),
                
            ],
            pointStyle: PointStyle(pointSize: 8, borderColour:.yellow, fillColour: .green, lineWidth: 6, pointType: .filled, pointShape: .circle),
            style: LineStyle(lineColour: ColourStyle(colour: CustomColor.primaryColor), lineType: .curvedLine))
        
        
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
        
        
        
        
        let chartData = LineChartData(dataSets       : data,
                                      chartStyle     : chartStyle)
        
        
        
        return chartData
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(safeAreaInsets: EdgeInsets())
    }
}

