//
//  CreateBudgetView.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import SwiftUI

struct CreateBudgetView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // Mark: - State Variables for User Input
    
    @State var showAmtKeybd = false
    @State var recieveAlerts = false
    @State var amount = ""
    @State var isCategoryshown = false
    @State var sliderValue = 50.0
    @State var category = SelectDataModel(id: "", desc: "")
    @State var categoryData = [SelectDataModel(id: "1", desc: "Food", Image: .Custom.camera, color: .red),
                               SelectDataModel(id: "2", desc: "Fuel", Image: .Custom.bell, color: .green),
                               SelectDataModel(id: "3", desc: "Shopping", Image: .Custom.bell, color: .yellow),
                               SelectDataModel(id: "4", desc: "Clothes", Image: .Custom.bell, color: .blue),
                               SelectDataModel(id: "5", desc: "Fee", Image: .Custom.bell, color: .black)]
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                NavigationBar(title: "Create Budget", top: geometry.safeAreaInsets.top) {
                    mode.wrappedValue.dismiss()
                }
                Spacer()
                Text("How much do yo want to spend?")
                    .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                    .font(.system(size: 18, weight: .medium))
                    .padding([.leading], 26)
                AmountInputWidget(amount: amount)
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(CustomColor.baseLight)
                    .padding([.top], 13)
                    .onTapGesture {
                        withAnimation {
                            showAmtKeybd.toggle()
                        }
                    }
                
                addDetailsView(geometry)
                    .padding([.top], 18)
            }
            .overlay(KeyboardWidget(geometry: geometry, amount: $amount, isShowing: $showAmtKeybd), alignment: .center)
            .background(Rectangle().foregroundColor(getBgColor()))
            .edgesIgnoringSafeArea([.all])
            
        }
    }
    
    
    
    @ViewBuilder private func addDetailsView(_ geometry: GeometryProxy) -> some View {
        VStack {
            SelectorWidgetView(hint: "Category", text: $category, data: $categoryData)
                .padding([.top], 24)
            
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Receive Alert")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(CustomColor.baseDark_25)
                        .padding([.bottom], 4)
                    Text(getAlertDesc(sliderValue))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(CustomColor.baseLight_20)
                }
                Spacer()
                Toggle(isOn: $recieveAlerts.animation()) {}
            }
            .padding([.top], 40)
            VStack {
                
                SliderWidgetView(percentage: $sliderValue, minLimit: 1, maxLimit: 100)
                    .padding([.horizontal] , 20)
                    .frame(height: recieveAlerts ? 30 : 0)
                    .padding([.vertical] , 10).isHidden(!recieveAlerts)
            }
            
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
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
        let value = recieveAlerts ? "\(intValue)" : "some value"
        return "Receive alert when it reaches \(value) percent of your buget."
    }
    
    func getBgColor() -> Color {
        CustomColor.primaryColor
    }
    
    
}

