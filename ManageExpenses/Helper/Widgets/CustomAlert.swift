//
//  CustomAlert.swift
//  ManageExpenses
//
//  Created by Ali Murad on 04/11/2022.
//

import SwiftUI

struct CustomAlert {
    var title: String
    func show(action: @escaping(() -> Void)) -> some View {
        VStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(CustomColor.baseDark)
                .multilineTextAlignment(.center)
                .padding([.horizontal], 20)
                .padding([.top], 25)
            
            ButtonWidgetView(title: "Ok", style: .primaryButton) {
                action()
            }
            .padding([.horizontal, .top], 20)
            .padding([.bottom], 25)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15)
        .padding([.all], 20)
        
    }
}
