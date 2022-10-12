//
//  PageControlView.swift
//  Workout
//
//  Created by murad on 06/10/2022.
//

import SwiftUI

struct PageControlView: View {
    
    var numberOfPages: Int
    var size: CGFloat
    
    @Binding var currentPage: Int
    let spacesSize = 10
    let margins = 40
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<numberOfPages) { index in
                    Circle()
                        .frame(width: size, height: size)
                        .foregroundColor(index <= self.currentPage ? CustomColor.primaryColor : CustomColor.primaryColor.opacity(0.5))
                        .onTapGesture(perform: { self.currentPage = index })
                }
            }
        }
        
    }
  
}
