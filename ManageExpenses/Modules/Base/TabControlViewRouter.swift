//
//  HomeViewRouter.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

enum Page {
     case home
     case tranactions
     case budget
     case user
 }

class TabControlViewRouter: ObservableObject {
    @Published var currentPage: Page = .home
}
