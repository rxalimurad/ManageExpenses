//
//  ProgressBarWidgetView.swift
//  ManageExpenses
//
//  Created by murad on 29/10/2022.
//

import SwiftUI

struct ProgressBarWidgetView: View {
    var percentage: Double
    var color: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(CustomColor.baseLight_60)
                    .cornerRadius(5)
                    .frame(height: 10)
                Rectangle()
                    .foregroundColor(color)
                    .frame(height: 10)
                    .cornerRadius(5)
                    .frame(width: geometry.size.width * CGFloat(self.percentage / 100))
            }
            .frame(width: geometry.size.width)
        }
    }
}

struct ProgressBarWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarWidgetView(percentage: 50, color: .red)
    }
}
