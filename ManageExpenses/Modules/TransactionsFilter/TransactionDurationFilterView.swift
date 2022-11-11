//
//  TransactionDurationFilterView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 31/10/2022.
//

import SwiftUI

struct TransactionDurationFilterView: View {
    var safeAreaInsets: EdgeInsets
    @Binding var isfilterSheetShowing: Bool
    @Binding var type: String
    @State var customDateSeleced = false
    @Binding var dateFrom: Date
    @Binding var dateTo: Date
    @State var showDatePickerFrom = false
    @State var showDatePickerTo = false
    @ObservedObject var transViewModel: TransactionViewModel
    
    var body: some View {
        VStack {
            VStack {
                getBackButton()
                    .isShowing(customDateSeleced)
                    .isShowing(!showDatePickerTo && !showDatePickerFrom)
                HStack {
                    Text("Filter Transaction Duration")
                        .foregroundColor(CustomColor.baseDark)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Reset")
                            .padding([.vertical], 7)
                            .padding([.horizontal], 15)
                            .font(.system(size: 14, weight:.medium))
                            .foregroundColor(CustomColor.primaryColor)
                            .background(CustomColor.primaryColor.opacity(0.2))
                            .cornerRadius(16)
                    }
                    .frame(height: 32)
                }
                .isShowing(!customDateSeleced)
                HStack {
                    Text(customDateSeleced ? "Select Date Range" :  "Filter By")
                        .foregroundColor(CustomColor.baseDark)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    
                }
                .padding([.top], customDateSeleced ? 0 : 22)
                
                SingleFilterSelectionView(selectedOpts: $type, options: FilterDuration.allCases.map({$0.rawValue})) { selectedOption in
                    if FilterDuration(rawValue: selectedOption) == .custom {
                        withAnimation {
                            customDateSeleced.toggle()
                        }
                        
                    }
                }
                .padding([.top], 16)
                .isShowing(!customDateSeleced)
                getDateSelectionView()
                    .isShowing(customDateSeleced)
                
                ButtonWidgetView(title: customDateSeleced ? "Ok" : "Apply", style: .primaryButton) {
                    if customDateSeleced {
                        if customDateSeleced {
                            customDateSeleced = false
                            transViewModel.refresh()
                            isfilterSheetShowing.toggle()
                        } else {
                            customDateSeleced = true
                        }
                        
                       
                    }
                    else {
                        transViewModel.refresh()
                        isfilterSheetShowing.toggle()
                    }
                    
                }
                .padding([.top], 34)
                .padding([.bottom], 16)
                
            }
            .padding([.horizontal], 16)
            .isShowing(!showDatePickerTo && !showDatePickerFrom)
            
            VStack {
                Text("From Date")
                    .font(.system(size: 16, weight: .bold))
                    .isShowing(showDatePickerFrom)
                DatePicker("", selection: $dateFrom,
                           in: ...dateTo,
                           displayedComponents: [.date])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden().isShowing(showDatePickerFrom)
                .environment(\.timeZone, TimeZone(abbreviation: "UTC")!)
                Text("To Date")
                    .font(.system(size: 16, weight: .bold))
                    .isShowing(showDatePickerTo)
                DatePicker("", selection: $dateTo,
                           in: dateFrom...Date(),
                           displayedComponents: [.date])
                .environment(\.timeZone, TimeZone(abbreviation: "UTC")!)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden().isShowing(showDatePickerTo)
                ButtonWidgetView(title: "Ok", style: .primaryButton) {
                    withAnimation {
                        showDatePickerTo = false
                        showDatePickerFrom = false
                    }
                }
            }.isShowing(showDatePickerTo || showDatePickerFrom)
        }
    }
    @ViewBuilder func getDateSelectionView() -> some View {
        VStack {
            HStack(spacing: 8) {
                Text(dateFrom.dateToShow)
                    .onTapGesture {
                        withAnimation {
                            showDatePickerFrom.toggle()
                        }
                    }
                Spacer()
                Text("To")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Text(dateTo.dateToShow)
                    .onTapGesture {
                        withAnimation {
                            showDatePickerTo.toggle()
                        }
                    }
            }
            
        }
        .padding([.bottom], 16 + safeAreaInsets.bottom)
        .isShowing(customDateSeleced)
        .padding([.top], 20)
        
    }
    @ViewBuilder func getBackButton() -> some View {
        HStack {
            Button {
                withAnimation {
                    self.customDateSeleced.toggle()
                }
            } label: {
                Image.Custom.navBack
                    .renderingMode(.template)
                    .foregroundColor(CustomColor.baseDark)
            }
            
            Spacer()
        }
    }
    
}
