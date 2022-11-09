//
//  AboutUsView.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import SwiftUI

struct AboutUsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack{
            NavigationBar(title: "About Us", top: 0, titleColor: CustomColor.baseDark, action: {
                mode.wrappedValue.dismiss()
            })
           
            Image.Custom.appIcon
                .resizable()
                .frame(width: 200, height: 200)
                .padding([.top], 30)
            Group {
                HStack {
                    Text("Application Name")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(getAppName())
                }
                Divider()
                    .foregroundColor(CustomColor.baseLight_20)
                    .padding([.vertical], 10)
                HStack {
                    Text("Version")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(getAppVersion())
                }
                Divider()
                    .foregroundColor(CustomColor.baseLight_20)
                    .padding([.vertical], 10)
                HStack {
                    Text("Code Version")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(getRevision())
                }
               
            }
            .padding([.horizontal], 20)
            
            
            
            
            Spacer()
            Text("©2020-2030 Volution Technologies. All Right Reserved.")
                .foregroundColor(CustomColor.baseLight_20)
                .font(.system(size: 12, weight: .medium))
        }
        
        }
    
    func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return ""

    }
    func getRevision() -> String {
        if let appRevision = Bundle.main.infoDictionary?["REVISION"] as? String {
            return appRevision
        }
        return ""

    }
    func getAppName() -> String {
        if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return ""
    }
    }

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
