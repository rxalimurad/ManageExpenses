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
    let action: (PlusMenuAction) -> Void
    let widthAndHeight: CGFloat = 56
    let imgWidthAndHeight: CGFloat  = 32
    var body: some View {
        VStack {
            HStack(spacing: 50) {
                ZStack {
                    Circle()
                        .foregroundColor(CustomColor.blue)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image.Custom.transferBtn
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        
                        .frame(width: imgWidthAndHeight, height: imgWidthAndHeight)
                        .foregroundColor(.white)
                }
                
            }.onTapGesture {
                action(.convert)
            }
            
            HStack(spacing: 50) {
                ZStack {
                    Circle()
                        .foregroundColor(CustomColor.green)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image.Custom.incomeBtn
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                       
                        .frame(width: imgWidthAndHeight, height: imgWidthAndHeight)
                        .foregroundColor(.white)
                }.onTapGesture {
                    action(.income)
                }
                
                
                
                
                ZStack {
                    Circle()
                        .foregroundColor(CustomColor.red)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                    Image.Custom.expenseBtn
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                       
                        .frame(width: imgWidthAndHeight, height: imgWidthAndHeight)
                        .foregroundColor(.white)
                }.onTapGesture {
                    action(.expense)
                }
                
            }
        }
        .transition(.scale)
    }
}
