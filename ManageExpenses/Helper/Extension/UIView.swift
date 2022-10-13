//
//  UIView.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import SwiftUI

extension View {
  @ViewBuilder func isShowing(_ showing: Bool) -> some View {
        if showing {
            self
        }
    }
}
