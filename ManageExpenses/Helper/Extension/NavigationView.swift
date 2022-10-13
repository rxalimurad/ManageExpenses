//
//  NavigationView.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI
extension View {
    @ViewBuilder func setNavigation(title: String, action: @escaping () -> Void) -> some View {
        self.navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(id: "", placement: .navigationBarLeading) {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "arrow.backward").foregroundColor(.black)
                    }
                    
                }
                
            }
    }
    
}
