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
    @State var isValidEmail = false
    @State var isValidPassword = false
    @State var isValidName = false
    
    var viewModel = SignUpViewModel()
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                InputWidgetView(hint:"Name", properties: InputProperties(maxLength: 40, minLength: 3), text: $name, isValidField: $isValidName)
                    .padding([.top], 56)
                    .padding([.leading, .trailing], 16)
                InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $emailAddress, isValidField: $isValidEmail)
                    .padding([.top], 16)
                    .padding([.leading, .trailing], 16)
                
                InputWidgetView(hint:"Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $password, isValidField: $isValidPassword)
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
                
                //NavigationLink(destination: SignupVerification()) {
                    ButtonWidgetView(title: "Sign Up", style: .primaryButton, action: {
                        viewModel.createUser(name: name, email: emailAddress, password: password)
                    })
                        .padding([.top], 27)
                        .padding([.trailing, .leading], 16)
                        .disabled(!validation())
                    
                //}.disabled(!validation())
                
                
                
             
                Spacer()
                
                NavigationLink(destination: LoginView()) {
                    Group {
                        Text("Already have an account? ")
                            .foregroundColor(CustomColor.baseLight_20)
                        +
                        Text("Login")
                            .foregroundColor(CustomColor.primaryColor)
                    }
                    .font(.system(size: 16, weight: .medium))
                    .padding([.bottom], 20)
                    
                }
                
                
                
            }
            
            .setNavigation(title: "Sign Up") {
                mode.wrappedValue.dismiss()
            }
            
        }
        
        
        
    }
    func validation() -> Bool {
        isValidName && isValidEmail && isValidPassword && isTermsAccepted
    }
}

struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
        
    }
}

