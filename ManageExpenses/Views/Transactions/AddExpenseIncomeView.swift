//
//  AddExpenseIncomeView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI

struct AddExpenseIncomeView: View {
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

struct AddExpenseIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseIncomeView()
    }
}
