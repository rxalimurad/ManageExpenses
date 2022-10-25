//
//  ProfileView.swift
//  ManageExpenses
//
//  Created by murad on 25/10/2022.
//

import SwiftUI

struct ProfileView: View {
    var safeAreaInsets: EdgeInsets
    var body: some View {
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .strokeBorder(CustomColor.baseLight, lineWidth: 5)
                        Circle()
                            .strokeBorder(CustomColor.primaryColor, lineWidth: 2)
                        Image.Custom.google
                            .resizable()
                            .frame(width: 76, height: 76)
                    }
                    .frame(width: 80, height: 80)
                    
                    VStack(alignment: .leading ,spacing: 8) {
                        Text("Username")
                            .foregroundColor(CustomColor.baseLight_20)
                            .font(.system(size: 14, weight: .medium))
                        Text("Ali Murad")
                            .foregroundColor(CustomColor.baseDark_75)
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    Spacer()
                    Image.Custom.edit
                }
                .padding([.horizontal], 20)
                .padding([.top], safeAreaInsets.top + 30)
                
                VStack {
                    
                }
                
                Spacer()
            }
            .background(ColoredView(color: CustomColor.baseLight_60))
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
