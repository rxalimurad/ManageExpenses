//
//  NavigationBar.swift
//  ManageExpenses
//
//  Created by murad on 18/10/2022.
//

import Foundation
import SwiftUI

struct NavigationBar: View {
    let title: String
    let action: () -> Void
    let titleColor: Color = CustomColor.baseLight
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                Image.Custom.navBack
                    .renderingMode(.template)
                    .foregroundColor(titleColor)
                    .frame(width: 52, height: 52)
            }
            Spacer()
            Text(title)
                .font(.system(size:18, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
                .foregroundColor(titleColor)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Spacer()
            Image("")
                .frame(width: 32, height: 32)
            
        }
    }
}
