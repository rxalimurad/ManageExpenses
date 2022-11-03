//
//  FinancialReportView.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import SwiftUI

struct FinancialReportView: View {
    var viewModel =  FinancialReportViewModel()
    var safeAreaInsets: EdgeInsets
    @State var isDurationFilterSheetShowing = false
    @State var isfilterSheetShowing = false
    @State var customDateSeleced = false
    @State var selectedTab = 0
    var financialData = [FinanicalReportModel]()
  
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
        animation: .default)
    private var recentTransactions: FetchedResults<Transaction>
    
    var body: some View {
        VStack {
            NavigationBar(title: "Financial Report", top: 0, titleColor: CustomColor.baseDark) {
                mode.wrappedValue.dismiss()
            }
            
            headerView
            PieChart(chartData: PieChartData(dataSets: PieDataSet(dataPoints: viewModel.getPoints(transactions: recentTransactions), legendTitle: ""), metadata: ChartMetadata()))
                .frame(height: 200)
            SegmentedControlWidgetView(items: ["\nExpense\n", "\nIncome\n"], selectedIndex: $selectedTab, padding: 1, fontSize: 16, textColor: CustomColor.primaryColor, bgColor: CustomColor.primaryColor_20)
                .padding([.top], 25)
                .padding([.leading, .trailing], 16)
            FinancialDetailView()
                
            
            Spacer()
        }
       
        .fullScreenCover(isPresented: $isDurationFilterSheetShowing) {
            ZStack (alignment: .bottom) {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isDurationFilterSheetShowing.toggle()
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
                

            }.padding([.top, .bottom], 5)
                
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
    
    private func durationFilterSheet() ->  some View {
        //,,..
        VStack {
            Button {
                isDurationFilterSheetShowing.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
                   
            }
            
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            customDateSeleced.toggle()
                        }
                    } label: {
                        Image.Custom.navBack
                            .renderingMode(.template)
                            .foregroundColor(CustomColor.baseDark)
                    }

                   Spacer()
                }.padding([.horizontal], 16)
                    .padding([.bottom], 20)
                
                HStack(spacing: 8) {
//                    DateSelectionCellView(title: "From Date") {
//
//                    }
//                    DateSelectionCellView(title: "To Date") {
//
//                    }
                    
                }
                ButtonWidgetView(title: "Ok", style: .primaryButton) {
                    withAnimation {
                        customDateSeleced.toggle()
                    }
                }
                .padding([.top], 20)
                
            }
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + safeAreaInsets.bottom)
            .isShowing(customDateSeleced)
            .padding([.top], 20)
            
            VStack(spacing: 8) {
                BottomSelectionCellView(title: "Today") {
                    
                }
                BottomSelectionCellView(title: "This Week") {
                    
                }
                BottomSelectionCellView(title: "This Month") {
                    
                }
                BottomSelectionCellView(title: "This Year") {
                    
                }
                BottomSelectionCellView(title: "Custom Range") {
                    withAnimation {
                        customDateSeleced.toggle()
                    }
                }
            }
            .padding([.top], 48)
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + safeAreaInsets.bottom)
            .isShowing(!customDateSeleced)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
        .edgesIgnoringSafeArea([.all])
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
    @ViewBuilder func FinancialDetailView() -> some View {
      
        ScrollView(.vertical) {
            VStack {
                ForEach(0 ..< viewModel.getFinanicalData(transactions: recentTransactions).count) {index  in
                    FinancialReportCellView(analyingData: viewModel.getFinanicalData(transactions: recentTransactions)[index])
                }
                
            }
            .padding([.horizontal], 32)
            .padding([.vertical], 10)
        }
    }
}

