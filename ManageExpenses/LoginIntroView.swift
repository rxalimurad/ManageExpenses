//
//  ContentView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct LoginIntroView: View {
    var body: some View {
        NavigationView {
            VStack {
                LoginIntroWidgetView(model: LoginIntroModel(pages: [
                    LoginIntroPage(id: "1", title: "Gain total control of your money", desc: "Become your own money manager and make every cent count", image: "controlMoney"),
                    
                    LoginIntroPage(id: "2", title: "Know where your money goes", desc: "Track your transaction easily, with categories and financial report ", image: "knowMoney"),
                    
                    LoginIntroPage(id: "3", title: "Planning ahead", desc: "Setup your budget for each category so you in control", image: "planMoney"),
                    
                ]))
                Group {
                    NavigationLink(destination: SignUpView()) {
                        ButtonWidgetView(title: "Sign Up", style: .primaryButton) {}.disabled(true)
                    }
                    ButtonWidgetView(title: "Login", style: .secondaryButton) {}.disabled(true)
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroView()
    }
}
