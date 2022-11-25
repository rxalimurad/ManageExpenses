//
//  ManageExpensesApp.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI
import FirebaseCore
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        requestNotification()
        scheduleNotification()
        return true
    }
    
    private func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}

@main
struct ManageExpensesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegat
    @StateObject var sessionService = SessionService()
    @StateObject var network = NetworkMonitor()

    @State private var isSplashShowing = true {
        didSet {
            print("set")
        }
    }
    
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
                        .fullScreenCover(isPresented: $network.disconnected, content: {
                            Text("No Internet")
                        })
                        .environmentObject(sessionService)
                    
                case .loggedOut:
                    LoginView()
                        .environmentObject(sessionService)
                    
                }
            }
        }
        
    }
}
