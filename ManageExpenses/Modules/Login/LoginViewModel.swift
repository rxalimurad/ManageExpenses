//
//  LoginViewModel.swift
//  ManageExpenses
//
//  Created by murad on 01/11/2022.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
//    @State var  = ""
//    @State var password = ""
    
    func sendEmailVerificationCode(emailAddress: String) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendSignInLink(toEmail: emailAddress,
                                   actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
              print(error.localizedDescription)
              return
            }
            // The link was successfully sent. Inform the user.
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            print("Check your email for link")
            // ...
        }
    }
    
}
