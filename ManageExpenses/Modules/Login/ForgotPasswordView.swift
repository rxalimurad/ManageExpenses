//
//  ResetLoginView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var emailAddress = ""
    
    var body: some View {
        VStack {
            Text("Don’t worry.\nEnter your email and we’ll send you a link to reset your password.")
                .foregroundColor(CustomColor.baseDark)
                .font(.system(size: 24, weight: .semibold))
                .padding([.top], 69)
                .padding([.leading, .trailing], 16)
                .multilineTextAlignment(.leading)
            
            InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 40, regex: Constants.regex.email), text: $emailAddress, isValidField: .constant(true))
                .padding([.top], 46)
                .padding([.leading, .trailing], 16)
            

            
            NavigationLink(destination: ForgotPasswordConfirmationView()) {
                ButtonWidgetView(title: "Continue", style: .primaryButton, action: {
                    
                }).allowsHitTesting(false)
                    .padding([.top], 32)
                    .padding([.trailing, .leading], 16)
            }
            
            
        
            
            Spacer()
            
        }.setNavigation(title: "Forgot Password") {
            mode.wrappedValue.dismiss()
        }
        
        
    }
}

struct ResetLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
