//
//  signUpView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct SignUpView: View {
    @State var name = ""
    @State var emailAddress = ""
    @State var password = ""
    @State var isTermsAccepted = false
    @State var isTermsShowing = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                InputWidgetView(hint:"Name", properties: InputProperties(maxLength: 40), text: $name)
                    .padding([.top], 56)
                    .padding([.leading, .trailing], 16)
                InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $emailAddress)
                    .padding([.top], 16)
                    .padding([.leading, .trailing], 16)
                
                InputWidgetView(hint:"Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $password)
                    .padding([.top], 16)
                    .padding([.leading, .trailing], 16)
                
                HStack(spacing: 0) {
                    Image(systemName: isTermsAccepted ? "checkmark.square.fill": "checkmark.square")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding([.trailing], 10)
                        .foregroundColor(CustomColor.primaryColor)
                        .onTapGesture {
                            isTermsAccepted.toggle()
                        }
                    
                    HStack {
                        Text("By signing up, you agree to the ")
                            .foregroundColor(CustomColor.baseDark)
                        
                        +
                        Text("Terms of Service and Privacy Policy")
                            .foregroundColor(CustomColor.primaryColor)
                    }.onTapGesture {
                        isTermsShowing.toggle()
                    }.sheet(isPresented: $isTermsShowing) {
                        WebView(type: .terms)
                    }
                    
                    
                    .font(.system(size: 14, weight: .medium))
                }
                .padding([.top], 17)
                .padding([.leading, .trailing], 16)
                
                NavigationLink(destination: SignupVerification()) {
                    ButtonWidgetView(title: "Sign Up", style: .primaryButton, action: {
                        
                    }).allowsHitTesting(false)
                        .padding([.top], 27)
                        .padding([.trailing, .leading], 16)
                        .disabled(!validation())
                    
                }.disabled(!validation())
                
                
                
                Text("Or with")
                    .foregroundColor(CustomColor.baseLight_20)
                    .font(.system(size: 14, weight: .medium))
                    .padding([.top, .bottom], 12)
                
                ButtonWidgetView(title: "Sign in with Apple",
                                 image: Image.Custom.apple,
                                 style: .blackButton, action: {
                    
                })
                .padding([.trailing, .leading], 16)
                
                Spacer()
                
                NavigationLink(destination: LoginView()) {
                    Group {
                        Text("Already have an account? ")
                            .foregroundColor(CustomColor.baseLight_20)
                        +
                        Text("Login")
                            .foregroundColor(CustomColor.primaryColor)
                    }.font(.system(size: 16, weight: .medium))
                    
                }
                
                
                
            }
        }
        
        .setNavigation(title: "Sign Up") {
            mode.wrappedValue.dismiss()
        }
        
        
        
        
    }
    func validation() -> Bool {
        if self.emailAddress.isEmpty || !self.isTermsAccepted || self.name.isEmpty || self.password.isEmpty {
            return false
        }
        return true
    }
}

struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
        
    }
}

