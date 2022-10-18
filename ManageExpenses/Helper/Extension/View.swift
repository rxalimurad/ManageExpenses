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
                        Image.Custom.navBack
                            .renderingMode(.template)
                            .foregroundColor(titleColor)
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
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
        func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
   
}
