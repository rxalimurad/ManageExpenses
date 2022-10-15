//
//  PlusMenu.swift
//  ManageExpenses
//
//  Created by murad on 15/10/2022.
//

import SwiftUI

struct PlusMenu: View {
   
  let widthAndHeight: CGFloat
   
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
            }
          }
      }
      .transition(.scale)
  }
}
