//
//  PlusMenu.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

enum PlusMenuAction {
    case income
    case expense
    case convert
}

struct PlusMenu: View {
    
    let widthAndHeight: CGFloat
    let action: (PlusMenuAction) -> Void
    var body: some View {
        VStack {
            HStack(spacing: 50) {
                ZStack {
                    Circle()
                        .foregroundColor(CustomColor.primaryColor)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                        .foregroundColor(.white)
                }
                
            }.onTapGesture {
                action(.convert)
            }
            
            HStack(spacing: 50) {
                ZStack {
                    Circle()
                        .foregroundColor(CustomColor.primaryColor)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image(systemName: "record.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                        .foregroundColor(.white)
                }.onTapGesture {
                    action(.income)
                }
                
                
                
                
                ZStack {
                    Circle()
                        .foregroundColor(CustomColor.primaryColor)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image(systemName: "folder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                        .foregroundColor(.white)
                }.onTapGesture {
                    action(.expense)
                }
                
            }
        }
        .transition(.scale)
    }
}
