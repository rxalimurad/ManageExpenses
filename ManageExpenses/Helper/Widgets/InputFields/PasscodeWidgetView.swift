//
//  PasscodeWidgetView.swift
//  ManageExpenses
//
//  Created by murad on 14/10/2022.
//

import SwiftUI
import Combine
//,,..import Introspect

public struct PasscodeWidgetView: View {
    let maxDigits: Int = 6
    @State  var attemps = 0
    @State var pin: String = ""
    @Binding var validPin: String
    @State var color = CustomColor.baseLight_20
    
    
    public var body: some View {
        ZStack(alignment: .leading) {
            pinDots
            backgroundField
        }
    }
    
    
    
    private var pinDots: some View {
        HStack(spacing: 10) {
            ForEach(0 ..< maxDigits) { index in
                self.getImageName(at: index)
                    .frame(width: 20, height: 20)
            }
        }.modifier(Shake(animatableData: CGFloat(attemps)))
    }
    
    private var backgroundField: some View {
        return TextField("", text: $pin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
//            .introspectTextField { textField in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    textField.becomeFirstResponder()
//                }
//            }
            .onChange(of: Just(pin), perform: { _ in
                DispatchQueue.main.async {
                    if pin.count > maxDigits {
                        pin = String(pin.prefix(maxDigits))
                    } else if pin.count == maxDigits {
                        validate()
                    } else {
                        color = CustomColor.baseLight_20
                    }
                }
            })
        
    }
    
    
    private func validate() {
        if pin != validPin {
            color = .red //,,..
            withAnimation {
                attemps += 1
            }
        } else {
            color = .green //,,..
        }
    }
    
    private func getImageName(at index: Int) -> AnyView {
        if index >= self.pin.count {
            return AnyView(
                Image.Custom.circleFill
                    .font(.system(size: 16, weight: .thin, design: .default))
                    .foregroundColor(color)
            )
        }
        
        return AnyView(
            Text("\(self.pin.digits[index])")
                .font(.system(size: 32, weight: .bold, design: .default))
                .foregroundColor(color)
        )
    }
}

