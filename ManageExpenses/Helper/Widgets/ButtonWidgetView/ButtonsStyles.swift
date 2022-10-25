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
        .font(.system(size: 18, weight:.semibold))
        .foregroundColor(CustomColor.baseLight_80)
        .background(isEnabled ? CustomColor.primaryColor : CustomColor.primaryColor.opacity(0.5))
        .cornerRadius(16)
    }
  
}
struct SecondaryButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .font(.system(size: 18, weight:.semibold))
        .foregroundColor(CustomColor.primaryColor)
        .background(CustomColor.primaryColor.opacity(0.2))
        .cornerRadius(16)
    }
  
}

struct WhiteButton: ButtonStyle {
   
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .font(.system(size: 18, weight:.semibold))
        .foregroundColor(CustomColor.baseDark_50)
        .background(CustomColor.baseLight)
        .overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(CustomColor.baseLight_60))
        .cornerRadius(16)
    }
  
}
struct SecondaryButtonSmall: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .font(.system(size: 14, weight:.medium))
        .foregroundColor(CustomColor.primaryColor)
        .background(CustomColor.primaryColor.opacity(0.2))
        .cornerRadius(16)
    }
  
}

extension ButtonStyle where Self == WhiteButton {
    static var whiteButton: WhiteButton { .init() }
}

extension ButtonStyle where Self == SecondaryButton {
    static var secondaryButton: SecondaryButton { .init() }
}
extension ButtonStyle where Self == SecondaryButtonSmall {
    static var secondaryButtonSmall: SecondaryButtonSmall { .init() }
}

extension ButtonStyle where Self == PrimaryButton {
    static var primaryButton: PrimaryButton { .init() }
}

