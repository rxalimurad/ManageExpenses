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
    @State var type: String = PlusMenuAction.expense.rawValue
    @State var sortBy: String = FilterSortingBy.newest.rawValue
    @State var showCateogory = false
    @State var categoryData = [SelectDataModel(id: "1", desc: "Food", Image: .Custom.camera, color: .red),
                               SelectDataModel(id: "2", desc: "Fuel", Image: .Custom.bell, color: .green),
                               SelectDataModel(id: "3", desc: "Shopping", Image: .Custom.bell, color: .yellow),
                               SelectDataModel(id: "4", desc: "Clothes", Image: .Custom.bell, color: .blue),
                               SelectDataModel(id: "5", desc: "Fee", Image: .Custom.bell, color: .black)]
    
    var body: some View {
        VStack {
            HStack {
                Text("Filter Transaction")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                ButtonWidgetView(title: "Reset", style: .secondaryButtonSmall) {
                    
                }
                .frame(width: 78, height: 32)
            }
            HStack {
                Text("Filter By")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                
            }
            .padding([.top], 22)
            
            SingleFilterSelectionView(selectedOpts: $type, options: PlusMenuAction.allCases.map({$0.rawValue}))
                .padding([.top], 16)
            HStack {
                Text("Sort By")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                
            }
            .padding([.top], 16)
            SingleFilterSelectionView(selectedOpts: $sortBy, options: FilterSortingBy.allCases.map({$0.rawValue}))
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
                    ForEach(0 ..< categoryData.count) { index in
                        Button {
                            withAnimation {
                                categoryData[index].isSelected.toggle()
                            }
                        } label: {
                            SelectionCell(title: categoryData[index].desc, color: categoryData[index].color, img: categoryData[index].Image, isSelected: categoryData[index].isSelected)
                                .padding([.horizontal], 16)
                        }

                    }
                    
                    ButtonWidgetView(title: "Ok", style: .primaryButton) {
                        withAnimation {
                            showCateogory.toggle()
                        }
                    }
                    .padding([.top], 30)
                }
                
                .transition(.move(edge: .bottom))
                .padding([.all], 20)
                .frame(maxWidth: .infinity)
                .background(ColoredView(color: .gray.opacity(0.15)))
                .background(ColoredView(color: CustomColor.baseLight))
                .cornerRadius(15)
        }
    }
}

struct TransactionFilterView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionFilterView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), isfilterSheetShowing: .constant(true))
    }
}
