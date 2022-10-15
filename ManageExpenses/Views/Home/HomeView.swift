//
//  HomeView.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                ZStack {
                    Circle()
                        .strokeBorder(CustomColor.baseLight, lineWidth: 5)
                    Circle()
                        .strokeBorder(CustomColor.primaryColor, lineWidth: 2)
                    Image.Custom.google
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .frame(width: 38, height: 38)
                .padding([.leading], 16)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Image.Custom.downArrow
                        .padding([.leading ], 13)
                    Text("October")
                        .font(.system(size: 14, weight: .medium))
                        .padding([.top, .bottom], 11)
                        .padding([.trailing], 16)
                }.overlay(RoundedRectangle(cornerRadius: 40, style: .circular).stroke(CustomColor.baseLight_60, lineWidth: 1)
                            
                )
               
                Spacer()
                Image.Custom.bell
                    .padding([.trailing], 21)
            }.padding([.top, .bottom], 12)
            
            
            Text("Account Balance")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
            Text("$9,400")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(CustomColor.baseDark_75)
            
            HStack {
                Group {
                    ZStack {
                        Color.green
                    HStack  {
                       
                        Image.Custom.inflow
                        VStack {
                            Text("Income")
                            Text("$5000")
                        }
                        }
                    }
                   
                    
                    
                }
                Group {
                    ZStack {
                        Color.red
                    HStack  {
                       
                        Image.Custom.outflow
                        VStack {
                            Text("Expenses")
                            Text("$5000")
                        }
                        }
                    }
                   
                    
                    
                }
            }
            
            Spacer()
            
            Text("--")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
