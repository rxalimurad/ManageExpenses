//
//  SignUpViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 02/11/2022.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {
    
    
    func createUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print(error!.localizedDescription)
                return
            }
            print("\(user.email!) created")
            Auth.auth().currentUser?.sendEmailVerification { error in
              print("email send ")
            }
            
        }
    }
    
    
}
