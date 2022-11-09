//
//  ContentView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct LoginIntroView<ViewModel: LoginIntroViewModelType>: View {
    var viewModel: ViewModel
    @Binding var showIntro: Bool
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                TabView() {
                    ForEach(viewModel.getIntroPage()) { page in
                        LoginIntroPageView(pageData: page)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
            
            
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                showIntro.toggle()
            }
            .padding([.trailing, .leading], 16)
            
            .padding([.bottom], 20)
            
        }.navigationBarTitle("")
            .navigationBarHidden(true)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroView(viewModel: LoginIntroViewModel(), showIntro: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")
        
    }
}

