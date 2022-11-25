//
//  BudgetDetailView.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import SwiftUI

struct BudgetDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isDeleteConfirmationShown = false
    weak var updateDelegate: UpdateBudget?
    @State var showCreatBudget = false
    var viewModel: BudgetDetailViewModel
 
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                NavigationBar(title: "Detail Budget", top: 0, titleColor: CustomColor.baseDark, action: {
                    mode.wrappedValue.dismiss()
                }, rightBtnImage: .Custom.delete) {
                        isDeleteConfirmationShown.toggle()
                }
                
                HStack(spacing: 8) {
                    transImageView
                        .frame(width: 32, height: 32)
                        .padding([.leading], 16)
                        .padding([.vertical], 16)
                    Text(viewModel.budget.category.desc.capitalized)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(CustomColor.baseDark)
                        .padding([.trailing], 16)
                        .padding([.vertical], 16)
                }
                .overlay( RoundedRectangle(cornerRadius: 16) .stroke(CustomColor.baseLight_60))
                .padding([.top], 32)
                
                Text("Remaining")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(CustomColor.baseDark)
                    .padding([.top], 32)
                
                Text("\(Utilities.getFormattedAmount(amount: (Double(viewModel.budget.limit)!  -  viewModel.spending)))")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundColor(CustomColor.baseDark)
                    .padding([.top], 3)
                
                ProgressBarWidgetView(percentage: viewModel.percentage, color: viewModel.budget.category.color)
                    .padding([.top, .horizontal], 32)
                
                VStack {
                    ZStack {
                        Color.red
                        HStack(spacing: 12) {
                            Image.Custom.warning
                                .renderingMode(.template)
                                .foregroundColor(CustomColor.baseLight)
                            Text("You’ve exceed the limit")
                                .foregroundColor(CustomColor.baseLight)
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .cornerRadius(15)
                    .frame(height: 40)
                    .padding([.top], 32)
                    .padding([.horizontal], 78)
                    .padding([.bottom], 100)
                }.isShowing(viewModel.isLimitExceed)

              
                
                Spacer()
                
                ButtonWidgetView(title: "Edit", style: .secondaryButton) {
                    showCreatBudget.toggle()
                }
                .padding([.bottom, .horizontal], 16)
              
            }
            .fullScreenCover(isPresented: $isDeleteConfirmationShown) {
                ZStack (alignment: .bottom) {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isDeleteConfirmationShown.toggle()
                        }
                    logoutSheet(geometry)
                }
                .background(ColoredView(color: .clear))
                .edgesIgnoringSafeArea(.all)
            }
            .fullScreenCover(isPresented: $showCreatBudget) {
                CreateBudgetView(viewModel: CreateBudgetViewModel(service: FirestoreService(), excluded: [], budget: viewModel.budget), isEditMode: false, updateDelegate: updateDelegate)
               
            }
        }
    }
    
    private var transImageView: some View {
        ZStack {
            Color.green.opacity(0.2)
            Image(systemName: "fork.knife")
                .renderingMode(.template)
                .foregroundColor(Color.green)
                .frame(width: 18, height: 18)
                .padding([.all], 8)
        }
        .cornerRadius(8)
        
    }
    
    private func logoutSheet(_ geometry: GeometryProxy) ->  some View {
        VStack {
            Button {
                isDeleteConfirmationShown.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
            }

            Text("Remove this budget?")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 20)
            Text("Are you sure do you wanna remove this budget?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
                .padding([.horizontal], 16)
                .padding([.top], 20)
            
            HStack(spacing: 16) {
                ButtonWidgetView(title: "No", style: .secondaryButton) {
                    
                }
                ButtonWidgetView(title: "Yes", style: .primaryButton) {
                    viewModel.deleteBudget(budget: viewModel.budget) {
                        isDeleteConfirmationShown.toggle()
                        mode.wrappedValue.dismiss()
                        updateDelegate?.refreshView()
                    }
                }
                
            }
            .padding([.top], 16)
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + geometry.safeAreaInsets.top)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
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
}
