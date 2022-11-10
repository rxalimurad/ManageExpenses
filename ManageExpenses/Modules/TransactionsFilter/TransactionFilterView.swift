//
//  TransactionFilterView.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import SwiftUI

struct TransactionFilterView: View {
    var safeAreaInsets: EdgeInsets
    @Binding var isfilterSheetShowing: Bool
    @Binding var sortedBy: String
    @Binding var filterBy: String
    @ObservedObject var transViewModel: TransactionViewModel
    @State private var showCateogory = false
    @Binding var categoryData: [SelectDataModel]
    
    var body: some View {
        VStack {
            HStack {
                Text("Filter Transaction")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                
                Button {
                    sortedBy = SortedBy.newest.rawValue
                    filterBy = PlusMenuAction.all.rawValue
                    categoryData = Utilities.getCategories()
                    
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
            HStack {
                Text("Filter By")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                
            }
            .padding([.top], 22)
            
            SingleFilterSelectionView(selectedOpts: $filterBy, options: PlusMenuAction.allCases.map({$0.rawValue}))
                .padding([.top], 16)
            HStack {
                Text("Sort By")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                
            }
            .padding([.top], 16)
            SingleFilterSelectionView(selectedOpts: $sortedBy, options: SortedBy.allCases.map({$0.rawValue}))
                .padding([.top], 16)
            
            HStack {
                Text("Category")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                
            }
            .padding([.top], 16)
            HStack {
                Text("Filter Transaction")
                    .foregroundColor(CustomColor.baseDark_25)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Button {
                    withAnimation {
                        showCateogory.toggle()
                    }
                } label: {
                    Text("\(categoryData.filter({ $0.isSelected}).count) Selected")
                        .foregroundColor(CustomColor.baseLight_20)
                        .font(.system(size: 14, weight: .semibold))
                    Image.Custom.downArrow.rotationEffect(Angle(degrees: 270))
                }
                
                
            }
            .padding([.top], 34)
            
            ButtonWidgetView(title: "Apply", style: .primaryButton) {
                isfilterSheetShowing.toggle()
                transViewModel.fetchTransactions()
            }
            .padding([.top], 34)
            .padding([.bottom], 16)
        }
        .padding([.horizontal], 16)
        .overlay(getCategorySelectionView(),alignment: .bottom)
    }
    
    @ViewBuilder func getCategorySelectionView() -> some View {
        if showCateogory {
            VStack {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(0 ..< categoryData.count) { index in
                            Button {
                                withAnimation {
                                    categoryData[index].isSelected.toggle()
                                }
                            } label: {
                                SelectionCell(title: categoryData[index].desc, color: categoryData[index].color, img: categoryData[index].Image, isSelected: categoryData[index].isSelected)
                                    .padding([.horizontal], 0)
                            }

                        }
                    }
                    
                    .transition(.move(edge: .bottom))
                    .padding([.vertical], 20)
                    .padding([.horizontal], 10)
                    
                }
                ButtonWidgetView(title: "Ok", style: .primaryButton) {
                    withAnimation {
                        showCateogory.toggle()
                    }
                }
                .padding([.top], 30)
            }
            .frame(maxWidth: .infinity)
            .background(ColoredView(color: .gray.opacity(0.15)))
            .background(ColoredView(color: CustomColor.baseLight))
            .cornerRadius(15)
        }
    }
}

//struct TransactionFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionFilterView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), isfilterSheetShowing: .constant(true))
//    }
//}
