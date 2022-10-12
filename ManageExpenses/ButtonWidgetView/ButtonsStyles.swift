//
//  ButtonsStyles.swift
//  Workout
//
//  Created by Ali Murad on 05/10/2022.
//

import Foundation
import SwiftUI


struct PrimaryButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .font(.system(size: 18, weight:.medium))
        .foregroundColor(CustomColor.baseLight_80)
        .padding()
        .background(CustomColor.primaryColor)
        .cornerRadius(16)
    }
  
}
struct SecondaryButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .font(.system(size: 18, weight:.medium))
        .foregroundColor(CustomColor.primaryColor)
        .padding()
        .background(CustomColor.primaryColor.opacity(0.2))
        .cornerRadius(16)
    }
  
}
extension ButtonStyle where Self == SecondaryButton {
    static var secondaryButton: SecondaryButton { .init() }
}

extension ButtonStyle where Self == PrimaryButton {
    static var primaryButton: PrimaryButton { .init() }
}

