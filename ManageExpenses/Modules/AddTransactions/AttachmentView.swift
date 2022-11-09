//
//  AttachmentView.swift
//  ManageExpenses
//
//  Created by murad on 22/10/2022.
//

import SwiftUI

struct AttachmentView: View {
    var image: Image
    var title: String
    var action: () -> Void
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                image
                    .renderingMode(.template)
                    .foregroundColor(CustomColor.primaryColor)
                    .padding([.horizontal], 23)
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(CustomColor.primaryColor)
            }
           
            .padding([.top], 20)
            .padding([.bottom], 16)
            .frame(maxWidth: .infinity)
        }
        .background(ColoredView(color: CustomColor.primaryColor.opacity(0.2)))
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
    }
}

struct AttachmentView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentView(image: Image.Custom.camera, title: "Camera", action: {})
    }
}
