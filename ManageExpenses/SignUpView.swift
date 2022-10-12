//
//  signUpView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct SignUpView: View {
    @State var emailAddress = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                InputWidgetView(hint:"Email", properties: InputProperties(maxLength: 20, minLength: 2, regex: Constants.regex.email), text: $emailAddress)
                    .padding([.all], 30)
                    
                InputWidgetView(hint:"Password", properties: InputProperties(maxLength: 20, minLength: 2, regex: Constants.regex.email, isSecure: true), text: $emailAddress)
                    .padding([.trailing, .leading, .bottom], 30)
                ButtonWidgetView(title: "Sign Up", style: .primaryButton, action: {
                    
                })
                    .padding([.trailing, .leading, .bottom], 30)
                   
                    
                
            }
                
    
                
        }.setNavigation(title: "Sign Up") {
            mode.wrappedValue.dismiss()
        }
    }
}

struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

extension NavigationView {
    func setNavigation(title: String, action: @escaping () -> Void) -> some View {
        self.navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(id: "", placement: .navigationBarLeading) {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "arrow.backward").foregroundColor(.black)
                    }
                    
                }
                
            }
    }
    
}
