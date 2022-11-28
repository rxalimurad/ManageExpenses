//
//  CustomAlert.swift
//  ManageExpenses
//
//  Created by Ali Murad on 04/11/2022.
//

import SwiftUI

struct CustomAlert {
    var title: String
    func show(action: @escaping(() -> Void)) -> some View {
        VStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(CustomColor.baseDark)
                .multilineTextAlignment(.center)
                .padding([.horizontal], 20)
                .padding([.top], 25)
            
            ButtonWidgetView(title: "Ok", style: .primaryButton) {
                action()
            }
            .padding([.horizontal, .top], 20)
            .padding([.bottom], 25)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15)
        .padding([.all], 20)
        
    }
}

struct ConnectionAlert {
    func show(action: @escaping(() -> Void)) -> some View {
        VStack {
            LottieView(lottieFile: Constants.animationFile.noInternetAnimation, speed: 2)
                .frame(height: 100)
            Text("Waiting for internet connection")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(CustomColor.red)
                .multilineTextAlignment(.center)
                .padding([.horizontal], 20)
                .padding([.top], 15)
                .padding([.bottom], 25)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15)
        .padding([.all], 20)
        
    }
}
