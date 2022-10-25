//
//  ResetPasswordView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct ResetPasswordView: View {
    @State var emailAddress = ""
    @State var password = ""
    @State var confirmPassword = ""

    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
         
            
            InputWidgetView(hint:"New Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $password)
                .padding([.top], 56)
                .padding([.leading, .trailing], 16)
            
            InputWidgetView(hint:"Confirm New Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $password)
                .padding([.top], 24)
                .padding([.leading, .trailing], 16)
            
            NavigationLink(destination: LoginIntroView(viewModel: LoginIntroViewModel())) {
                ButtonWidgetView(title: "Continue", style: .primaryButton, action: {
                    
                }).allowsHitTesting(false)
                    .padding([.top], 32)
                    .padding([.trailing, .leading], 16)
            }
            NavigationLink(destination: ForgotPasswordView()) {
                Text("Forgot Password?")
                    .foregroundColor(CustomColor.primaryColor)
                    .font(.system(size: 18, weight: .semibold))
                    .padding([.top, .bottom], 33)
            }
            
            
            NavigationLink(destination: SignUpView()) {
                Group {
                    Text("Don’t have an account yet? ")
                        .foregroundColor(CustomColor.baseLight_20)
                    +
                    Text("Sign Up")
                        .underline()
                        .foregroundColor(CustomColor.primaryColor)
                }.font(.system(size: 16, weight: .medium))
                    .padding([.trailing, .leading], 50)
            }
            
            
            
            Spacer()
            
        }.setNavigation(title: "Reset Password") {
            mode.wrappedValue.dismiss()
        }
        
        
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
