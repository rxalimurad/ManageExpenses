//
//  ViewForServiceAPI.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import SwiftUI

struct ViewForServiceAPI: View {
    @Binding var state: ServiceAPIState
    var body: some View {
        switch state {
        case .inprogress:
            Color.black.opacity(0.3).edgesIgnoringSafeArea([.all])
            VStack {
                LottieView(lottieFile: Constants.animationFile.loadingAnimation, speed: 1)
                    .frame(height: 100)
            }
        case .failed(let error):
            Color.black.opacity(0.3).edgesIgnoringSafeArea([.all])
            
            CustomAlert(title: error.errorDescription).show() {
                state = .na
            }.transition(.scale)
        default:
            EmptyView()
                .transition(.scale)
        }
    }
}
