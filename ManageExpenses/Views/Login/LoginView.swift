//
//  LoginView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct LoginView: View {
    @State var emailAddress = ""
    @State var password = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $emailAddress)
                .padding([.top], 56)
                .padding([.leading, .trailing], 16)
            
            InputWidgetView(hint:"Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $password)
                .padding([.top], 24)
                .padding([.leading, .trailing], 16)
            
            
            NavigationLink(destination: SetupAccountView()) {
                ButtonWidgetView(title: "Login", style: .primaryButton, action: {
                    
                }).disabled(true)
                    .padding([.top], 40)
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
            
        }.setNavigation(title: "Login") {
            mode.wrappedValue.dismiss()
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
