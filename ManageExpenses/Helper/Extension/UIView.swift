//
//  UIView.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import SwiftUI

extension UIView {
  
    public func asUIImage() -> UIImage {
           let renderer = UIGraphicsImageRenderer(bounds: bounds)
           return renderer.image { rendererContext in
               layer.render(in: rendererContext.cgContext)
           }
       }
}
