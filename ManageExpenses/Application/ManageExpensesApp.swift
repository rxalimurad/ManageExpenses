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
            if isSplashShowing {
                SplashView(isShowing: $isSplashShowing)
            } else {
                LoginIntroView(viewModel: LoginIntroViewModel())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        
    }
}
