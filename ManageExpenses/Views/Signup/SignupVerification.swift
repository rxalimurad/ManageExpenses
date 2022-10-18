//
//  SignupVerification.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI

struct SignupVerification: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var attempts = 1
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter your Verification Code")
                .foregroundColor(CustomColor.baseDark)
                .font(.system(size: 36, weight: .medium))
                .padding([.leading, .trailing], 16)
                .multilineTextAlignment(.leading)
            
            PasscodeWidgetView(validPin: .constant("000000"))
                .padding([.leading, .trailing], 16)
                .padding([.top], 20)
            Text("4:40")
                .foregroundColor(CustomColor.primaryColor)
                .font(.system(size: 18, weight: .semibold))
                .padding([.leading, .trailing], 16)
                .padding([.top], 15)
                .multilineTextAlignment(.leading)
            Group {
                Text("We send verification code to your email ")
                    .foregroundColor(CustomColor.baseDark_50)
                +
                Text("brajaoma*****@gmail.com")
                    .foregroundColor(CustomColor.primaryColor)
                +
                Text(". You can check your inbox.")
                    .foregroundColor(CustomColor.baseDark_50)
            }
                .font(.system(size: 16, weight: .medium))
                .padding([.leading, .trailing, .top], 16)
            Text("I didn’t received the code? Send again")
                .underline()
                .foregroundColor(CustomColor.primaryColor)
                    .padding([.leading, .trailing, .top], 16)
            
            NavigationLink(destination: LoginView()) {
                ButtonWidgetView(title: "Verify", style: .primaryButton, action: {
                    withAnimation(.default) {
                                        self.attempts += 1
                                    }
                }).disabled(true)
                    .padding([.trailing, .leading], 16)
                    .padding([.top], 30)
            }
            Spacer()
        }.setNavigation(title: "Verifications") {
            mode.wrappedValue.dismiss()
        }
        
        
    }
}

struct SignupVerification_Previews: PreviewProvider {
    static var previews: some View {
        SignupVerification()
    }
}
