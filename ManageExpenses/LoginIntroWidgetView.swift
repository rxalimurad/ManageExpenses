//
//  LoginIntroWidgetView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct LoginIntroWidgetView: View {
    @State var currentPage = 0
    var model: LoginIntroModel
    init(model: LoginIntroModel) {
        self.model = model
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(CustomColor.primaryColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(CustomColor.primaryColor).withAlphaComponent(0.2)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TabView() {
                ForEach(model.pages) { page in
                    LoginIntroPageView(pageData: page)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}

struct LoginIntroWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroWidgetView(model: LoginIntroModel(pages: [LoginIntroPage(id: "1", title: "Gain total control of your money", desc: "Become your own money manager and make every cent count", image: "controlMoney"), LoginIntroPage(id: "2", title: "Gain total control of your money", desc: "Become your own money manager and make every cent count", image: "controlMoney")]))
    }
}


