//
//  HomeView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct TabControlView: View {
    @EnvironmentObject var sessionService: SessionService
    
    @StateObject var viewRouter: TabControlViewRouter
    @State var showPopUp = false
    @State var showNewEntryScreen = false
    @State var newEntryType: PlusMenuAction?
    @ObservedObject var homeViewModel = HomeViewModel(dbHandler: FirestoreTransactionsService())
    @ObservedObject var transViewModel = TransactionViewModel(dbHandler: FirestoreTransactionsService())
    var body: some View {
        ZStack {
            if showPopUp {
                
                LinearGradient(gradient: Gradient(colors:
                                                    [CustomColor.primaryColor.opacity(0.0),
                                                     CustomColor.primaryColor.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            }
            
            GeometryReader { geometry in
                VStack {
                    Group {
                        switch viewRouter.currentPage {
                        case .home:
                            HomeView(viewModel: homeViewModel, safeAreaInsets: geometry.safeAreaInsets)
                        case .tranactions:
                            TransactionTabView(safeAreaInsets: geometry.safeAreaInsets, viewModel: transViewModel)
                        case .budget:
                            BudgetView(safeAreaInsets: geometry.safeAreaInsets)
                        case .user:
                            ProfileView(safeAreaInsets: geometry.safeAreaInsets)
                                .environmentObject(sessionService)
                        }
                    }.allowsHitTesting(!showPopUp)
                    Spacer()
                    ZStack {
                        HStack {
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, icon: Image.Custom.home, tabName: "Home").allowsHitTesting(!showPopUp)
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .tranactions, width: geometry.size.width/5, height: geometry.size.height/28, icon: Image.Custom.transaction, tabName: "Transactions").allowsHitTesting(!showPopUp)
                            
                            
                            ZStack {
                                Circle()
                                    .foregroundColor(CustomColor.primaryColor)
                                    .frame(width: 56, height: 56)
                                
                                Image.Custom.plus
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30 , height: 30)
                                    .foregroundColor(CustomColor.baseLight)
                                    .rotationEffect(Angle(degrees: showPopUp ? 45 : 0))
                                
                            }.onTapGesture {
                                withAnimation {
                                    showPopUp.toggle()
                                }
                            }
                            .offset(y: -geometry.size.height/8/2)
                            
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .budget, width: geometry.size.width/5, height: geometry.size.height/28, icon: Image.Custom.budget, tabName: "Budget").allowsHitTesting(!showPopUp)
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .user, width: geometry.size.width/5, height: geometry.size.height/28, icon: Image.Custom.user, tabName: "Profile").allowsHitTesting(!showPopUp)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height/8)
                        .background(CustomColor.baseLight_80.opacity(0)).shadow(radius: 0)
                    }.overlay(plusMenu(geometry: geometry), alignment: .center)
                    
                }
                .edgesIgnoringSafeArea(.all)
                
            }
        }.fullScreenCover(isPresented: $showNewEntryScreen) {
            
        } content: {
            if let newEntryType = newEntryType {
                AddExpenseIncomeView(newEntryType: newEntryType, homeViewModel: homeViewModel, transViewModel: transViewModel)
            }
        }
        
    }
    
    @ViewBuilder private func plusMenu(geometry: GeometryProxy) -> some View {
        if showPopUp {
            PlusMenu() {action in
                self.newEntryType = action
                showNewEntryScreen.toggle()
                showPopUp.toggle()
            }
            .offset(y: -geometry.size.height/6)
            .isShowing(showPopUp)
            
        }
    }
}

struct TabControlView_Previews: PreviewProvider {
    static var previews: some View {
        TabControlView(viewRouter: TabControlViewRouter())
    }
}
