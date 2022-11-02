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
    @State var isValidEmail = false
    @State var isValidPassword = false
    
    var viewModel =  LoginViewModel()
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $emailAddress, isValidField: $isValidEmail)
                .padding([.top], 56)
                .padding([.leading, .trailing], 16)
                
            
            InputWidgetView(hint:"Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $password, isValidField: $isValidPassword)
                .padding([.top], 24)
                .padding([.leading, .trailing], 16)
            
            
            NavigationLink(destination: SetupAccountView()) {
                ButtonWidgetView(title: "Login", style: .primaryButton, action: {
                    viewModel.sendEmailVerificationCode(emailAddress: emailAddress)
                }).allowsHitTesting(false)
                    .padding([.top], 40)
                    .padding([.trailing, .leading], 16)
                    .disabled(!validation())
            }.disabled(!validation())
            NavigationLink(destination: ForgotPasswordView()) {
                Text("Forgot Password?")
                    .foregroundColor(CustomColor.primaryColor)
                    .font(.system(size: 18, weight: .semibold))
                    .padding([.top, .bottom], 33)
            }
            
            ButtonWidgetView(title: "Sign in with Apple",
                             image: Image.Custom.apple,
                             style: .blackButton, action: {
                
            })
            .padding([.trailing, .leading], 16)
            Spacer()
            HStack {
                ButtonWidgetView(title: "Google",
                                 image: Image.Custom.google,
                                 style: .googleButton, action: {
                    
                })
                
                ButtonWidgetView(title: "Facebook",
                                 image: Image.Custom.facebook,
                                 style: .fbButton, action: {
                    
                })
                
                
                
            }
            .padding([.trailing, .leading], 16)
            
            Spacer()
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
                    .padding([.bottom], 20)
            }
            
            
            
            
        }.setNavigation(title: "Login") {
            mode.wrappedValue.dismiss()
        }
    }
    
    func validation() -> Bool {
        return isValidEmail && isValidPassword
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
