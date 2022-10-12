//
//  signUpView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                .setNavigation() {
//                    self.mode.wrappedValue.dismiss()
//                }
        }
    }
}

struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

extension NavigationView {
    func setNavigation(action: @escaping ()-> Void) {
        self.navigationTitle("Sign Up")
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
