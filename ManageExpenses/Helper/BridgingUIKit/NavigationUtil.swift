//
//  NavigationUtil.swift
//  ManageExpenses
//
//  Created by Ali Murad on 04/11/2022.
//

import UIKit
struct NavigationUtil {
    static func popToRootView() {
        getLoginVC()
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }
    private static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        return nil
    }
    
    private static func  getLoginVC() {
        print(UIApplication.shared.windows.filter({ $0.isKeyWindow}))
    }
}
