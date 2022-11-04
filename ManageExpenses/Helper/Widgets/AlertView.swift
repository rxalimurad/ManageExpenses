//
//  AlertView.swift
//  ManageExpenses
//
//  Created by murad on 04/11/2022.
//

import SwiftUI
import AlertX
struct AlertView  {
    var title: String
    func show(action: @escaping(() -> Void)) -> AlertX {
        AlertX(title: Text(title),  buttonStack: [AlertX.Button.default(Text("OK"), action: {
            action()
        })], theme: .custom(windowColor: CustomColor.baseLight, alertTextColor: CustomColor.baseDark  , enableShadow: true, enableRoundedCorners: true, enableTransparency: false, cancelButtonColor: .white, cancelButtonTextColor: .white, defaultButtonColor: CustomColor.primaryColor, defaultButtonTextColor: CustomColor.baseLight), animation: AlertX.AnimationX.classicEffect())
    }
    
}
