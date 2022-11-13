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
    @ObservedObject var viewModel = BudgetViewModel(service: FirestoreService())
    @State var showCreatBudget = false
    @State var selectedBudget: BudgetDetail?
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Image.Custom.downArrow
                        .renderingMode(.template)
                        .foregroundColor(CustomColor.baseLight)
                        .rotationEffect(Angle(degrees: 90))
                        .hidden()
                    Spacer()
                    Text("Budget (\(Date().fullMonth))")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(CustomColor.baseLight)
                        .frame(maxWidth:. infinity)
                    Spacer()
                    Image.Custom.downArrow
                        .renderingMode(.template)
                        .foregroundColor(CustomColor.baseLight)
                        .rotationEffect(Angle(degrees: 270))
                        .hidden()
                }
                .padding([.top], safeAreaInsets.top)
                .padding([.horizontal], 27)
                if viewModel.budgetList.isEmpty {
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
                CreateBudgetView(viewModel: CreateBudgetViewModel(service: FirestoreService(), excluded: viewModel.budgetList.map({ $0.category.desc }), budget: nil), isEditMode: false, updateDelegate: viewModel)
            }
            .fullScreenCover(item: $selectedBudget, content: { budget in
                BudgetDetailView(budget: budget,updateDelegate: viewModel, spending: 1000)
            })
            
        }
    }
    
    
    
    @ViewBuilder private func addDetailsView(_ geometry: GeometryProxy) -> some View {
        VStack {
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.budgetList) { budget in
                    
                        Button {
                            selectedBudget = budget
                        } label: {
                            BudgetViewCell(budget: budget)
                        }
                        
                       
                    }
                }
                .padding([.top], 10)
            }
            
            Spacer()
            ButtonWidgetView(title: "Create a budget", style: .primaryButton) {
                withAnimation {
                    showCreatBudget.toggle()
                }
            }
            .padding([.top], 40)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
            
        }
        .padding([.horizontal], 16)
        
        .frame(maxHeight: .infinity)
        .background(
            Rectangle()
                .foregroundColor(CustomColor.baseLight_60)
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
