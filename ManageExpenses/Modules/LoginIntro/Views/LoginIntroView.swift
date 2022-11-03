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
                
                NavigationLink(destination: LoginView()) {
                    ButtonWidgetView(title: "Continue", style: .primaryButton) {}.allowsHitTesting(false)
                        .padding([.trailing, .leading], 16)
                }
                .padding([.bottom], 20)

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

