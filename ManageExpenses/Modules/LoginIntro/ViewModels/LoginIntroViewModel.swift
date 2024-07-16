//
//  LoginIntroViewModel.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI

protocol LoginIntroViewModelType {
    func getIntroPage() -> [LoginIntroPage]
}


final class LoginIntroViewModel: LoginIntroViewModelType {
    
    func getIntroPage() -> [LoginIntroPage] {
        let page1 = LoginIntroPage(id: "1", title: NSLocalizedString("Gain total control of your money", comment: "Title for intro page 1"), desc: NSLocalizedString("Become your own money manager and make every cent count", comment: "Description for intro page 1"), image: Image.Custom.controlMoney)
        let page2 = LoginIntroPage(id: "2", title: NSLocalizedString("Know where your money goes", comment: "Title for intro page 2"), desc: NSLocalizedString("Track your transaction easily, with categories and financial report", comment: "Description for intro page 2"), image: Image.Custom.knowMoney)
        let page3 = LoginIntroPage(id: "3", title: NSLocalizedString("Planning ahead", comment: "Title for intro page 3"), desc: NSLocalizedString("Setup your budget for each category so you in control", comment: "Description for intro page 3"), image: Image.Custom.planMoney)
        return [page1, page2, page3]
    }
}

