//
//  LoginView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sessionService: SessionService
    //MARK: - View Model
    @StateObject var viewModel =  LoginViewModel(service: LoginService())
    
    var body: some View {
        NavigationView {
            GeometryReader { _ in
                ZStack {
                    VStack {
                        InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $viewModel.userDetails.email, isValidField: $viewModel.isValidEmail)
                            .padding([.top], 56)
                            .padding([.leading, .trailing], 16)
                        
                        
                        InputWidgetView(hint:"Password", properties: InputProperties(maxLength: 20, minLength: 8, isSecure: true), text: $viewModel.userDetails.password, isValidField: $viewModel.isValidPassword)
                            .padding([.top], 24)
                            .padding([.leading, .trailing], 16)
                        
                        
                        
                        ButtonWidgetView(title: "Login", style: .primaryButton, action: {
                            viewModel.signin()
                        })
                            .padding([.top], 40)
                            .padding([.trailing, .leading], 16)
                            .disabled(!validation())
                        
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
                                viewModel.googleSignin()
                            })
                            
//                            ButtonWidgetView(title: "Facebook",
//                                             image: Image.Custom.facebook,
//                                             style: .fbButton, action: {
//                                
//                            })
                            
                            
                            
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
                    }
                    
                    ViewForServiceAPI(state: $viewModel.state)
                }
                
                .fullScreenCover(isPresented: $viewModel.showIntro, content: {
                    LoginIntroView(viewModel: LoginIntroViewModel(), showIntro: $viewModel.showIntro)
                })
                .setNavigation(title: "Login", showBackBtn: false) {}
            }
        }.onAppear() {
            self.viewModel.setupSession(session: self.sessionService)
        }
    }
    
    
    func validation() -> Bool {
        return viewModel.isValidEmail && viewModel.isValidPassword
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
