//
//  CustomPadding.swift
//  ManageExpenses
//
//  Created by Ali Murad on 31/10/2022.
//

import SwiftUI
import Foundation
struct CustomPadding: ViewModifier {
    let edges: Edge.Set
    let value: CGFloat
    
    init(_ edges: Edge.Set, _ value: CGFloat) {
        self.edges = edges
        self.value = value
    }
    
    func body(content: Content) -> some View {
        if self.edges == .top || self.edges == .bottom || self.edges == .vertical {
            return content
                .padding([edges], (value / 812) * UIScreen.main.bounds.size.height)
        } else {
            return content
                .padding([edges], (value / 375) * UIScreen.main.bounds.size.width)
        }
    }
}
