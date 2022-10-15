//
//  ForgotPasswordConfirmationView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct ForgotPasswordConfirmationView: View {
    var body: some View {
        VStack {
            Image.Custom.emailSent
                .resizable()
                .frame(width: 312, height: 312)
                .padding([.top], 32)
                .padding([.leading, .trailing], 31)
           
            Text("Your email is on the way")
                .foregroundColor(CustomColor.baseDark)
                .font(.system(size: 24, weight: .semibold))
                .padding([.top], 18)
                .padding([.leading, .trailing], 35)
            
            Text("Check your email test@test.com and follow the instructions to reset your password")
                .foregroundColor(CustomColor.baseDark_50)
                .font(.system(size: 16, weight: .medium))
                .padding([.leading, .trailing], 35)
                .multilineTextAlignment(.center)
                .padding([.top], 18)
            Spacer()
            NavigationLink(destination: ResetPasswordView()) {
                ButtonWidgetView(title: "Back to Login", style: .primaryButton, action: {
                    
                }).disabled(true)
                    .padding([.bottom], 50)
                    .padding([.trailing, .leading], 16)
            }
        
            
       
        }
            .navigationBarHidden(true)
    }
}

struct ForgotPasswordConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordConfirmationView()
    }
}
