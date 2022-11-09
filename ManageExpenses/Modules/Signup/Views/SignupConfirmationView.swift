//
//  SignupConfirmationView.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI


struct SignupConfirmationView: View {
    @Binding var email: String
    var body: some View {
        VStack {
            Image.Custom.emailSent
                .resizable()
                .frame(width: 312, height: 312)
                .padding([.top], 32)
                .padding([.leading, .trailing], 31)
            
            Text("Your email is on the way")
                .foregroundColor(CustomColor.baseDark)
                .font(.system(size: 24, weight: .semibold))
                .padding([.top], 18)
                .padding([.leading, .trailing], 35)
            
            Group {
                Text("A verifiction email has been sent to ")
                    .foregroundColor(CustomColor.baseDark_50)
                +
                Text("\(email)")
                    .foregroundColor(CustomColor.blue)
                +
                Text("\nKindly verify your email(Inbox/Spam) before logging in.")
                    .foregroundColor(CustomColor.baseDark_50)
            }
            .font(.system(size: 16, weight: .medium))
            .padding([.leading, .trailing], 20)
            .multilineTextAlignment(.center)
            .padding([.top], 18)
            Spacer()
            ButtonWidgetView(title: "Login", style: .primaryButton, action: {
                NavigationUtil.popToRootView()
            })
                .padding([.bottom], 50)
                .padding([.trailing, .leading], 16)
        }
        .navigationBarHidden(true)
    }
}

struct SignupConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        SignupConfirmationView(email: .constant("rxalimurad@gmail.com"))
    }
}
