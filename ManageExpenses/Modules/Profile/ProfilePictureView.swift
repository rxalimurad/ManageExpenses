//
//  ProfilePictureView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 25/11/2022.
//

import SwiftUI

struct ProfilePictureView: View {
    var name: String
    var size: CGFloat
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(CustomColor.primaryColor,lineWidth: 4)
                .background(Circle().foregroundColor(Color.red))
            Text(String(Array(name).first ?? "?"))
                .foregroundColor(.white)
                .font(.system(size: size/1.8, weight: .bold))
                .frame(width: size * 0.8, height: size * 0.8)
        }
            .frame(width: size, height: size)
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(name: "Murad", size: 80)
    }
}
