//
//  ManageExpensesApp.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ManageExpensesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegat
    @StateObject var sessionService = SessionService()
    @State private var isSplashShowing = true
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(CustomColor.primaryColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(CustomColor.primaryColor).withAlphaComponent(0.2)
    }
    var body: some Scene {
        WindowGroup {
            if isSplashShowing {
                SplashView(isShowing: $isSplashShowing)
            } else {
                switch sessionService.state {
                case .loggedIn:
                    TabControlView(viewRouter: TabControlViewRouter())
                        .environmentObject(sessionService)
                case .loggedOut:
                    LoginView()
                        .environmentObject(sessionService)

                        
                }
            }
        }
        
    }
}
