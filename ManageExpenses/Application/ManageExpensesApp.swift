//
//  ManageExpensesApp.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

@main
struct ManageExpensesApp: App {

    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(CustomColor.primaryColor)
             UIPageControl.appearance().pageIndicatorTintColor = UIColor(CustomColor.primaryColor).withAlphaComponent(0.2)
    }
    var body: some Scene {
        WindowGroup {
            TransactionView(transType: .food, transName: "Food", transDesc: "Buy a burger")
//            LoginIntroView(viewModel: LoginIntroViewModel())
            //TabControlView(viewRouter: TabControlViewRouter())
//            SignUpView()
        }
    }
}
