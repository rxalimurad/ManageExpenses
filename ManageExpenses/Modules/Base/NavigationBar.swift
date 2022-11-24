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
    let showRightBtn: Bool
    let action: () -> Void
    let rightBtnImage: Image?
    let rightBtnAction: (() -> Void)?
    
    init(title: String,
         top: CGFloat,
         titleColor: Color = CustomColor.baseLight,
         showBackBtn: Bool = true,
         showRightBtn: Bool = false,
         action: @escaping () -> Void,
         rightBtnImage: Image? = nil,
         rightBtnAction: (() -> Void)? = nil
    
    ) {
        self.title = title
        self.top = top
        self.titleColor = titleColor
        self.showBackBtn = showBackBtn
        self.action = action
        self.rightBtnImage = rightBtnImage
        self.rightBtnAction = rightBtnAction
        self.showRightBtn = showRightBtn
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
                rightBtnAction?()
            } label: {
                if rightBtnImage == nil {
                    Image.Custom.navBack
                    .renderingMode(.template)
                    .foregroundColor(titleColor)
                    .frame(width: 52, height: 52).hidden()
                }
                else {
                rightBtnImage?
                    .renderingMode(.template)
                    .foregroundColor(titleColor)
                    .frame(width: 52, height: 52)
                }
                    
            }.isShowing(showRightBtn)
        }.padding([.top], top)
    }
}
