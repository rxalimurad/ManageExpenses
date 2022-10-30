//
//  SliderWidgetView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 27/10/2022.
//

import SwiftUI

struct SliderWidgetView: View {
    @Binding var percentage: Double
    var minLimit: Double
    var maxLimit: Double
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                    .cornerRadius(5)
                    .frame(height: 10)
                Rectangle()
                    .foregroundColor(CustomColor.primaryColor)
                    .frame(height: 10)
                    .cornerRadius(5)
                    .frame(width: geometry.size.width * CGFloat(self.percentage / 100))
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .frame(width:  geometry.size.width * 0.2, height: 30)
                        .foregroundColor(CustomColor.primaryColor)
                        .cornerRadius(geometry.size.width * 0.5)
                    Text("\(Int(percentage))%")
                        .frame(width:  geometry.size.width * 0.2, height: 30)
                        .foregroundColor(CustomColor.baseLight)
                        .font(.system(size: 14, weight: .medium))
                }
                .offset(x: (geometry.size.width * CGFloat(self.percentage / 100) - (geometry.size.width * 0.1)), y: 0)
                
            }
            .frame(width: geometry.size.width)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    let percentageValue = Double(min(max(minLimit, Double(value.location.x / geometry.size.width * 100)), maxLimit))
                    self.percentage = percentageValue
                }))
            
        }
    }
}
