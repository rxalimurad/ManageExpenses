//
//  LoginIntroPageView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct LoginIntroPageView: View {
    var pageData: LoginIntroPage
    let imageSize = UIScreen.main.bounds.height * 0.3
    var body: some View {
        VStack {
            Image(pageData.image)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .padding([.bottom],40)
            Text(pageData.title)
                .font(.system(size: 32, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
                .padding([.bottom],20)
            Text(pageData.desc)
                .font(.body)
                .foregroundColor(Color(red: 0.569, green: 0.569, blue: 0.624))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20.0)
            
            
            
        }
    }
}

struct LoginIntroPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginIntroPageView(pageData: LoginIntroPage(id: "1", title: "Gain total control of your money", desc: "Become your own money manager and make every cent count", image: "controlMoney"))
            
        }
    }
}
