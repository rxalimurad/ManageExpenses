//
//  SetupAccountView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct SetupAccountView: View {

    var body: some View {
        VStack(alignment: .leading) {
            Text("Let’s setup your account!")
                .foregroundColor(CustomColor.baseDark)
                .font(.system(size: 36, weight: .medium))
                .padding([.top], 67)
                .padding([.leading, .trailing], 16)
                .multilineTextAlignment(.leading)
            Text("Let’s setup your account!")
                .foregroundColor(CustomColor.baseDark)
                .font(.system(size: 14, weight: .medium))
                .padding([.top], 37)
                .padding([.leading, .trailing], 16)
                .multilineTextAlignment(.leading)
            
            Spacer()
            NavigationLink(destination: AddNewBankView()) {
                ButtonWidgetView(title: "Let’s go", style: .primaryButton, action: {
                }).allowsHitTesting(false)
                    .padding([.bottom], 50)
                    .padding([.trailing, .leading], 16)
            }
        }.navigationBarHidden(true)
    }
}

struct SetupAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SetupAccountView()
    }
}
