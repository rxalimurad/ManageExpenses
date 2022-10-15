//
//  NavigationView.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import SwiftUI
extension View {
    @ViewBuilder func setNavigation(title: String, titleColor: Color? = Color.black, action: @escaping () -> Void) -> some View {
        self.navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            
            .toolbar {
                ToolbarItem(id: "", placement: .navigationBarLeading) {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "arrow.backward").foregroundColor(titleColor)
                    }
                    
                }
                ToolbarItem(id: "", placement: .principal) {
                    Button {
                        action()
                    } label: {
                        Text(title)
                            .font(.system(size:18, weight: .semibold))
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(titleColor)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    
                }
                
            }
    
    }
    
}
