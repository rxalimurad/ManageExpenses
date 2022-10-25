//
//  ContentView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct LoginIntroView<ViewModel: LoginIntroViewModelType>: View {
    var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    TabView() {
                        ForEach(viewModel.getIntroPage()) { page in
                            LoginIntroPageView(pageData: page)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                }
                
                NavigationLink(destination: SignUpView()) {
                    ButtonWidgetView(title: "Sign Up", style: .primaryButton) {}.allowsHitTesting(false)
                        .padding([.trailing, .leading], 16)
                }
                NavigationLink(destination: LoginView()) {
                ButtonWidgetView(title: "Login", style: .secondaryButton) {}.allowsHitTesting(false)
                    .padding([.bottom], 20)
                    .padding([.trailing, .leading], 16)
                }
            }.navigationBarTitle("")
                .navigationBarHidden(true)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroView(viewModel: LoginIntroViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                        .previewDisplayName("iPhone 12")
       
    }
}

