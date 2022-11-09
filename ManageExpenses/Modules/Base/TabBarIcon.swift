//
//  TabBarIcon.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct TabBarIcon: View {
    @StateObject var viewRouter: TabControlViewRouter
    let assignedPage: Page
     let width, height: CGFloat
    let icon: Image
    let tabName: String
     
     
     var body: some View {
         VStack {
            icon
                 .renderingMode(.template)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: width, height: height)
                 .padding(.top, 10)
                 
                 .foregroundColor(viewRouter.currentPage == assignedPage ? CustomColor.primaryColor : CustomColor.baseLight_20)
             Text(tabName)
                 .font(.footnote)
             Spacer()
         }.padding(.horizontal, -4)
             .onTapGesture {
                 withAnimation {
                     viewRouter.currentPage = assignedPage
                 }
             
             }             .foregroundColor(viewRouter.currentPage == assignedPage ? CustomColor.primaryColor : CustomColor.baseLight_20)

     }
 }

struct TabBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabBarIcon(viewRouter: TabControlViewRouter(), assignedPage: .home, width: 100, height: 100, icon: Image.Custom.home, tabName: "Home")
    }
}
