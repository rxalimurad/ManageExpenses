//
//  ManageExpensesApp.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

@main
struct ManageExpensesApp: App {
    let persistenceController = PersistenceController.shared

    @State private var isSplashShowing = true
    
    @State var amount = ""
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(CustomColor.primaryColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(CustomColor.primaryColor).withAlphaComponent(0.2)
    }
    var body: some Scene {
        WindowGroup {
            //            LoginIntroView(viewModel: LoginIntroViewModel())
//                        TabControlView(viewRouter: TabControlViewRouter())
            //            SignUpView()
            //            AddExpenseIncomeView(newEntryType: .income)
//            AddExpenseIncomeView(newEntryType: .convert)
//            if isSplashShowing {
//                SplashView(isShowing: $isSplashShowing)
//            } else {
////                LoginIntroView(viewModel: LoginIntroViewModel())
//                TabControlView(viewRouter: TabControlViewRouter())
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            }
            FinancialReportView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0  ))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            CreateBudgetView()
        }
    }
    
}
