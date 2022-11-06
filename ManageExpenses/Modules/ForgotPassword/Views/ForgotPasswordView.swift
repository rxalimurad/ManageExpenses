//
//  ResetLoginView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    //MARK: - View Model
    @StateObject var viewModel = ForgotPasswordViewModel(service: ForgotPasswordService())
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("Don’t worry.\nEnter your email and we’ll send you a link to reset your password.")
                    .foregroundColor(CustomColor.baseDark)
                    .font(.system(size: 24, weight: .semibold))
                    .padding([.top], 69)
                    .padding([.leading, .trailing], 16)
                    .multilineTextAlignment(.leading)
                
                NavigationLink(destination: ForgotPasswordConfirmationView(email: $viewModel.email), isActive: $viewModel.moveNext) { EmptyView() }
                InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $viewModel.email, isValidField: $viewModel.isValidEmail)
                    .padding([.top], 46)
                    .padding([.leading, .trailing], 16)
                
                ButtonWidgetView(title: "Continue", style: .primaryButton, action: {
                    viewModel.resetUser()
                })
                    .disabled(!validate())
                    .padding([.top], 32)
                    .padding([.trailing, .leading], 16)
                
                Spacer()
                
            }
            
            ViewForServiceAPI(state: $viewModel.state)
        }.setNavigation(title: "Forgot Password") {
            mode.wrappedValue.dismiss()
        }
    }
    
    private func validate() -> Bool {
        viewModel.isValidEmail
    }
}

struct ResetLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
