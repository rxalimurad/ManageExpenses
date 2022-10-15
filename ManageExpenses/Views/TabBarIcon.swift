//
//  TabBarIcon.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct TabBarIcon: View {
    @StateObject var viewRouter: HomeViewRouter
    let assignedPage: Page
     let width, height: CGFloat
     let systemIconName, tabName: String
     
     
     var body: some View {
         VStack {
             Image(systemName: systemIconName)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: width, height: height)
                 .padding(.top, 10)
             Text(tabName)
                 .font(.footnote)
             Spacer()
         }.padding(.horizontal, -4)
             .onTapGesture {
             viewRouter.currentPage = assignedPage
         }             .foregroundColor(viewRouter.currentPage == assignedPage ? .red : .black)

     }
 }

struct TabBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabBarIcon(viewRouter: HomeViewRouter(), assignedPage: .home, width: 100, height: 100, systemIconName: "homekit", tabName: "Home")
    }
}
