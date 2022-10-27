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
    @ViewBuilder func isShowing(_ showing: Bool) -> some View {
          if showing {
              self
          }
      }
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
          if !isHidden {
              self
          }
      }
    public func asUIImage() -> UIImage {
           let controller = UIHostingController(rootView: self)
            
           controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
           UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
            
           let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
           controller.view.bounds = CGRect(origin: .zero, size: size)
           controller.view.sizeToFit()
            
           // here is the call to the function that converts UIView to UIImage: `.asImage()`
           let image = controller.view.asUIImage()
           controller.view.removeFromSuperview()
           return image
       }
}
