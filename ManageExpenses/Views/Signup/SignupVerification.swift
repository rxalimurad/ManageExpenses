//
//  SignupVerification.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI

struct SignupVerification: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var body: some View {
        VStack {
            PasscodeWidgetView()
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
