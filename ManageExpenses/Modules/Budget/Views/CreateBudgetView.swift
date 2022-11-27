//
//  CreateBudgetView.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import SwiftUI

struct CreateBudgetView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: CreateBudgetViewModel
    var isEditMode: Bool
    weak var updateDelegate: UpdateBudget?
    var dismissDelegate: DismissView?
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    NavigationBar(title: (isEditMode ? "Edit Budget" : "Create Budget"), top: geometry.safeAreaInsets.top) {
                        mode.wrappedValue.dismiss()
                    }
                    Spacer()
                    Text("How much do yo want to spend?")
                        .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                        .font(.system(size: 18, weight: .medium))
                        .padding([.leading], 26)
                    AmountInputWidget(amount: viewModel.budget.limit)
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(CustomColor.baseLight)
                        .padding([.top], 13)
                        .onTapGesture {
                            withAnimation {
                                viewModel.showAmtKeybd.toggle()
                            }
                        }
                    
                    addDetailsView(geometry)
                        .padding([.top], 18)
                }
                ViewForServiceAPI(state: $viewModel.state)
            }
            .overlay(KeyboardWidget(geometry: geometry, amount: $viewModel.budget.limit, isShowing: $viewModel.showAmtKeybd), alignment: .center)
            .background(Rectangle().foregroundColor(getBgColor()))
            .edgesIgnoringSafeArea([.all])
            
        }
    }
    
    
    
    @ViewBuilder private func addDetailsView(_ geometry: GeometryProxy) -> some View {
        VStack {
            SelectorWidgetView(hint: "Category", text: $viewModel.budget.category, data: $viewModel.categoryData, disabled: isEditMode)
                .padding([.top], 24)
            
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Receive Alert")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(CustomColor.baseDark_25)
                        .padding([.bottom], 4)
                    Text(getAlertDesc(viewModel.budget.slider))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(CustomColor.baseLight_20)
                }
                Spacer()
                Toggle(isOn: $viewModel.budget.recieveAlerts.animation()) {}
            }
            .padding([.top], 40)
            VStack {
                
                SliderWidgetView(percentage: $viewModel.budget.slider, minLimit: 1, maxLimit: 100)
                    .padding([.horizontal] , 20)
                    .frame(height: viewModel.budget.recieveAlerts ? 30 : 0)
                    .padding([.vertical] , 10).isGone(!viewModel.budget.recieveAlerts)
            }
            
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                viewModel.updateBudget {
                    dismissDelegate?.dismiss()
                    mode.wrappedValue.dismiss()
                    
                    updateDelegate?.refreshView()
                }
            }
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            
        }
        .padding([.horizontal], 16)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .background(
            RoundedCorner(radius: 30)
                .foregroundColor(CustomColor.baseLight)
        )
        
    }
    
    func getAlertDesc(_ value: Double) -> String {
        let intValue = Int(value)
        let value = viewModel.budget.recieveAlerts ? "\(intValue)" : "some value"
        return "Receive alert when it reaches \(value) percent of your buget."
    }
    
    func getBgColor() -> Color {
        CustomColor.primaryColor
    }
    
    
}

