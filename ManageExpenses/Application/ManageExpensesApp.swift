//
//  ManageExpensesApp.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

@main
struct ManageExpensesApp: App {
    @State var isButtonShow = false
    @State var amount = ""
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(CustomColor.primaryColor)
             UIPageControl.appearance().pageIndicatorTintColor = UIColor(CustomColor.primaryColor).withAlphaComponent(0.2)
    }
    var body: some Scene {
        WindowGroup {
//            LoginIntroView(viewModel: LoginIntroViewModel())
//            TabControlView(viewRouter: TabControlViewRouter())
//            SignUpView()
//            AddExpenseIncomeView(newEntryType: .income)
           // KeyboardView()
            Button {
                isButtonShow.toggle()
            } label: {
                Text("Tap me!!!")
            }.sheet(isPresented: $isButtonShow) {
                KeyboardWidget(amount: $amount)
            }

        }
    }
}

