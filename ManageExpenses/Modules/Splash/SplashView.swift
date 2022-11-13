//
//  SplashView.swift
//  ManageExpenses
//
//  Created by murad on 24/10/2022.
//

import SwiftUI

struct SplashView: View {
    
    @Binding var isShowing: Bool
    var vm = SplashViewModel(service: FirestoreService())
    var body: some View {
        VStack {
            LottieView(lottieFile: Constants.animationFile.splashAnimation, speed: 2)
            LottieView(lottieFile: Constants.animationFile.loadingAnimation, speed: 1)
                .frame(height: 100)
            VStack {
                
            }
            
            
        }.onAppear() {
            vm.fetchBanks { success in
                if success {
                    withAnimation {
                        self.isShowing = false
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isShowing = false
                        }
                    }
                }
            }
        }
    }
}
