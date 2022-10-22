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
    let top: CGFloat
    let titleColor: Color
    let showBackBtn: Bool
    let action: () -> Void
    
    init(title: String, top: CGFloat, titleColor: Color = CustomColor.baseLight, showBackBtn: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.top = top
        self.titleColor = titleColor
        self.showBackBtn = showBackBtn
        self.action = action
    }
    
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                Image.Custom.navBack
                    .renderingMode(.template)
                    .foregroundColor(titleColor)
                    .frame(width: 52, height: 52)
            }.isShowing(showBackBtn)
            Spacer()
            Text(title)
                .font(.system(size:18, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
                .foregroundColor(titleColor)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                action()
            } label: {
                Image.Custom.navBack
                    .renderingMode(.template)
                    .foregroundColor(titleColor)
                    .frame(width: 52, height: 52).hidden()
            }
        }.padding([.top], top)
    }
}
