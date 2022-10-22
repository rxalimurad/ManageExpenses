//
//  SelectorView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 21/10/2022.
//

import SwiftUI

struct SelectionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 10) {
            NavigationBar(title: "Categories", top: 0, titleColor: CustomColor.baseDark, action: {
                mode.wrappedValue.dismiss()
            })

        
            ScrollView {
                ForEach(0 ..< 199) {_ in
                    SelectionCell(title: "Food", color: .red)
                        .padding([.horizontal], 16)
                }
            }
        }
      
    }
}
