//
//  AddNewBankVIew.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct AddNewBankView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    var body: some View {
        ZStack {
            CustomColor.primaryColor.edgesIgnoringSafeArea(.all)
        VStack {
         Spacer()
            
            
        }
       
        }
        .setNavigation(title: "Add new account", titleColor: CustomColor.baseLight) {
                mode.wrappedValue.dismiss()
            }
    }
}

struct AddNewBankVIew_Previews: PreviewProvider {
    static var previews: some View {
        AddNewBankView()
    }
}
