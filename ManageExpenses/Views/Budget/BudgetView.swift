//
//  BudgetView.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import SwiftUI

struct BudgetView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var safeAreaInsets: EdgeInsets
    var viewModel = BudgetViewModel()
    @State var showCreatBudget = false
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Image.Custom.downArrow
                        .renderingMode(.template)
                        .foregroundColor(CustomColor.baseLight)
                        .rotationEffect(Angle(degrees: 90))
                    Spacer()
                    Text("May")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(CustomColor.baseLight)
                        .frame(maxWidth:. infinity)
                    Spacer()
                    Image.Custom.downArrow
                        .renderingMode(.template)
                        .foregroundColor(CustomColor.baseLight)
                        .rotationEffect(Angle(degrees: 270))
                }
                .padding([.top], safeAreaInsets.top)
                .padding([.horizontal], 27)
                if viewModel.monthlyBudgetList.isEmpty {
                    addNRFView(geometry)
                        .padding([.top], 20)
                } else {
                    addDetailsView(geometry)
                }
                
            }
            .background(Rectangle().foregroundColor(getBgColor()))
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea([.all])
            .fullScreenCover(isPresented: $showCreatBudget) {
                CreateBudgetView()
            }
            
            
        }
    }
    
    
    
    @ViewBuilder private func addDetailsView(_ geometry: GeometryProxy) -> some View {
        VStack {
            
            VStack {
                ForEach(0 ..<  viewModel.monthlyBudgetList[0].budget.count, id: \.self) { index in
                    BudgetViewCell(budget: viewModel.monthlyBudgetList[0].budget[index])
                }
            }
            
            Spacer()
            ButtonWidgetView(title: "Create a budget", style: .primaryButton) {
               
            }
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            
        }
        .padding([.horizontal], 16)
        
        .frame(maxHeight: .infinity)
        .background(
            Rectangle()
                .foregroundColor(CustomColor.baseLight)
        )
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
    
    @ViewBuilder private func addNRFView(_ geometry: GeometryProxy) -> some View {
        VStack {
            
            VStack {
                Spacer()
                Text("You don’t have a budget.\nLet’s make one so you in control.")
                    .foregroundColor(CustomColor.baseLight_20)
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            Spacer()
            ButtonWidgetView(title: "Create a budget", style: .primaryButton) {
                withAnimation {
                    showCreatBudget.toggle()
                }
            }
            .padding([.bottom], 31)
            
        }
        .padding([.horizontal], 16)
        
        .frame(maxHeight: .infinity)
        .background(
            Rectangle()
                .foregroundColor(CustomColor.baseLight)
        )
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
    
    func getBgColor() -> Color {
        CustomColor.primaryColor
    }

    
}



struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView( safeAreaInsets: EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
