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
        ZStack {
            CustomColor.baseLight_60.edgesIgnoringSafeArea([.all])
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
                    .padding([.leading], 10)
                    
                    Spacer()
                    Image.Custom.edit
                }
                .padding([.horizontal], 20)
                .padding([.top], safeAreaInsets.top + 15)
                
                ZStack {
                    CustomColor.baseLight.edgesIgnoringSafeArea([.all])
                    VStack {
                        getSettingsCell(title: "Account", img: Image.Custom.account)
                        Divider()
                        getSettingsCell(title: "Settings", img: Image.Custom.settings)
                        Divider()
                        getSettingsCell(title: "Export Data", img: Image.Custom.exportData)
                        Divider()
                        getSettingsCell(title: "Logout", img: Image.Custom.logout)
                    }
                }
                .cornerRadius(20)
                .padding([.horizontal], 20)
                .frame(maxHeight: 356)
                Spacer()
            }
        }
        
        
    }
    
    func getSettingsCell(title: String, img: Image) -> some View {
        VStack {
            Spacer()
            HStack {
                img
                    .padding([.leading], 17)
                Text(title)
                Spacer()
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
