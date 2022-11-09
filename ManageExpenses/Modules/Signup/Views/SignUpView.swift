//
//  signUpView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct SignUpView: View {
    //MARK: - Environment
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    //MARK: - View Model
    @StateObject var vm = SignUpViewModel(service: SignupService())
   
    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack{
                    InputWidgetView(hint:"Name", properties: InputProperties(maxLength: 40, minLength: 3), text: $vm.userDetails.name, isValidField: $vm.isValidName)
                        .padding([.top], 56)
                        .padding([.leading, .trailing], 16)
                    InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $vm.userDetails.email, isValidField: $vm.isValidEmail)
                        .padding([.top], 16)
                        .padding([.leading, .trailing], 16)
                    NavigationLink(destination: SignupConfirmationView(email: $vm.userDetails.email), isActive: $vm.moveNext) { EmptyView() }
                    InputWidgetView(hint:"Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $vm.userDetails.password, isValidField: $vm.isValidPassword)
                        .padding([.top], 16)
                        .padding([.leading, .trailing], 16)
                    
                    HStack(spacing: 0) {
                        Group {
                            if vm.isTermsAccepted {
                                Image.Custom.checkedSquared
                                    .resizable()
                            } else {
                                Image.Custom.unCheckedSquared
                                    .resizable()
                            }
                        }
                        .frame(width: 24, height: 24)
                        .padding([.trailing], 10)
                        .foregroundColor(CustomColor.primaryColor)
                        .onTapGesture {
                            vm.isTermsAccepted.toggle()
                        }
                        
                        HStack {
                            Text("By signing up, you agree to the ")
                                .foregroundColor(CustomColor.baseDark)
                            
                            +
                            Text("Terms of Service and Privacy Policy")
                                .foregroundColor(CustomColor.primaryColor)
                        }.onTapGesture {
                            vm.isTermsShowing.toggle()
                        }.sheet(isPresented: $vm.isTermsShowing) {
                            WebView(type: .terms)
                        }
                        
                        
                        .font(.system(size: 14, weight: .medium))
                    }
                    .padding([.top], 17)
                    .padding([.leading, .trailing], 16)
                    
                    ButtonWidgetView(title: "Sign Up", style: .primaryButton, action: {
                        vm.createUser()
                    })
                    .padding([.top], 27)
                    .padding([.trailing, .leading], 16)
                    .disabled(!validation())
                    Spacer()
                    Button {
                        NavigationUtil.popToRootView()
                    } label: {
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
                ViewForServiceAPI(state: $vm.state)
            }
            
        }.setNavigation(title: "Sign Up") {
            mode.wrappedValue.dismiss()
        }
        
        
        
        
    }
    
    func validation() -> Bool {
        vm.isValidName && vm.isValidEmail && vm.isValidPassword && vm.isTermsAccepted
    }
}


struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
        
    }
}

