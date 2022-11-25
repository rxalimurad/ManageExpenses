//
//  SplashView.swift
//  ManageExpenses
//
//  Created by murad on 24/10/2022.
//

import SwiftUI

struct SplashView: View {
    
    @Binding var isShowing: Bool
    @State var tryAgain = false
    var vm = SplashViewModel(service: FirestoreService())
    var body: some View {
        VStack {
            ZStack {
                Text("Something went wrong, kindly check your internet connection and try again.").isHidden(!tryAgain)
                    .transition(.scale)
                    .padding([.horizontal], 20)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(CustomColor.baseDark)
                LottieView(lottieFile: Constants.animationFile.splashAnimation, speed: tryAgain ? 0 : 2).isHidden(tryAgain)
            }
            ZStack {
                if tryAgain {
                    Button {
                        withAnimation {
                            tryAgain = false
                        }
                        fetchData()
                    } label: {
                        ButtonWidgetView(title: "Try again", style: .primaryButton) {}
                            .padding([.horizontal], 20).allowsHitTesting(false)
                    }
                } else {
                    LottieView(lottieFile: Constants.animationFile.loadingAnimation, speed: 1)
                        .frame(height: 100)
                }
                
                
            }
            VStack {
                
            }
            
            
        }.onAppear() {
            fetchData()
        }
    }
    
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                tryAgain = true
            }
        }
        
        vm.fetchBanks { success in
            if success {
                vm.fetchBudgets { success in
                    if success {
                        withAnimation {
                            self.isShowing = false
                        }
                    }
                }
            }
        }
    }
}
