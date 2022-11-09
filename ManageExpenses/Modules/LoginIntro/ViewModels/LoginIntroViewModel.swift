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
    
    func getIntroPage() -> [LoginIntroPage]{
        let page1 = LoginIntroPage(id: "1", title: "Gain total control of your money", desc: "Become your own money manager and make every cent count", image: Image.Custom.controlMoney)
        let page2 = LoginIntroPage(id: "2", title: "Know where your money goes", desc: "Track your transaction easily, with categories and financial report ", image: Image.Custom.knowMoney)
        let page3 = LoginIntroPage(id: "3", title: "Planning ahead", desc: "Setup your budget for each category so you in control", image: Image.Custom.planMoney)
        return [page1, page2, page3]
    }
}
