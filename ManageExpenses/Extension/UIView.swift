//
//  UIView.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import SwiftUI

extension View {
  @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
}
