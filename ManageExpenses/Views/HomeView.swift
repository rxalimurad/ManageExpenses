//
//  HomeView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewRouter: HomeViewRouter
    @State var showPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .home:
                    Text("Home")
                case .liked:
                    Text("Liked")
                case .records:
                    Text("Records")
                case .user:
                    Text("User")
                }
                Spacer()
                ZStack {
                    if showPopUp {
                        PlusMenu(widthAndHeight: geometry.size.width/7)
                            .offset(y: -geometry.size.height/6)
                    }
                    
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "homekit", tabName: "Home")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .liked, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "heart", tabName: "liked")
                        
                        
                        ZStack {
                            Circle()
                                .foregroundColor(CustomColor.primaryColor)
                                .frame(width: 56, height: 56)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30 , height: 30)
                                .foregroundColor(CustomColor.baseLight)
                                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                            
                        }.onTapGesture {
                            withAnimation {
                                showPopUp.toggle()
                            }
                        }
                        .offset(y: -geometry.size.height/8/2)
                        
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .records, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "waveform", tabName: "Records")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .user, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "Account")
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height/8)
                .background(CustomColor.baseLight_80).shadow(radius: 0)
            }
            .edgesIgnoringSafeArea(.bottom)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewRouter: HomeViewRouter())
    }
}
