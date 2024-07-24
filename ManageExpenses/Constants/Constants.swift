//
//  Constants.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI

enum Constants {
    
    enum ads {
        static let banner = "ca-app-pub-6213982913612542/4119004839"
        static let interstitial = "ca-app-pub-6213982913612542/7912045650"
    }
    
    enum persistanceKey {
        static let currentUser = "currentUSer"
        static let currency = "currency"
    }
    
    enum regex {
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    enum format {
        static let time = "hh:mm a"
        static let date = "MMM d, yyyy"
    }
    
    enum bottomSheet {
        static let radius: CGFloat = 16
        static let indicatorHeight: CGFloat = 6
        static let indicatorWidth: CGFloat = 60
        static let snapRatio: CGFloat = 0.25
        static let minHeightRatio: CGFloat = 0.3
    }
    
    enum firestoreCollection {
        static let users = "Users"
        static let transactions = "Transactions"
        static let banks = "Banks"
        static let budget = "Budget"
    }
    
    enum animationFile {
        static let splashAnimation = "splashAnimation"
        static let loadingAnimation = "loadingAnimation"
        static let noInternetAnimation = "nointernet"
    }
    
    
}
