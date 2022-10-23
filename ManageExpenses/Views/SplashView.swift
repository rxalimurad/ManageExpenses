//
//  SplashView.swift
//  ManageExpenses
//
//  Created by murad on 24/10/2022.
//

import SwiftUI

struct SplashView: View {
    @Binding var isShowing: Bool
    var body: some View {
        VStack {
            LottieView(lottieFile: "splashAnimation", speed: 2)
            LottieView(lottieFile: "loadingAnimation", speed: 1)
                .frame(height: 100)
        }.onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.isShowing.toggle()
                }
            }
        }
  }
}
