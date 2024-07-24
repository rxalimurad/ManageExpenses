//
//  ManageExpensesApp.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI
import Sentry

import FirebaseCore
import UserNotifications
import GoogleSignIn
import GoogleMobileAds


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SentrySDK.start { options in
            options.dsn = "https://23357da59a98de56b49389a85cbb916d@o4505772399984640.ingest.us.sentry.io/4507656033533952"
            options.debug = true // Enabled debug when first installing is always helpful
            options.enableTracing = true 
            if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
                options.environment = appName
            } else {
                // Default value or error handling if bundle name is not available
                options.environment = "DefaultAppName"
            }
            // Uncomment the following lines to add more data to your events
             options.attachScreenshot = true // This adds a screenshot to the error events
             options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
        // Remove the next line after confirming that your Sentry integration is working.
        SentrySDK.capture(message: "This app uses Sentry! :)")

        FirebaseApp.configure()
        requestNotification()
        scheduleNotification()
        GADMobileAds.sharedInstance().start()
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
        content.title = NSLocalizedString("Manage It",comment: "")
        content.subtitle = NSLocalizedString("Did you forget to your today's expense?",comment: "")
        content.sound = UNNotificationSound.default
        var dateComponents = DateComponents()
            dateComponents.hour = 25
            dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
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
                            ZStack (alignment: .center) {
                                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                                ConnectionAlert().show() {}
                            }
                            .background(ColoredView(color: .clear))
                            .edgesIgnoringSafeArea(.all)
                        })
                        .environmentObject(sessionService)
                    
                case .loggedOut:
                    LoginView()
                        .fullScreenCover(isPresented: $network.disconnected, content: {
                            ZStack (alignment: .center) {
                                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                                ConnectionAlert().show() {}
                            }
                            .background(ColoredView(color: .clear))
                            .edgesIgnoringSafeArea(.all)
                        })
                        .environmentObject(sessionService)
                    
                }
            }
        }
        
    }
}
