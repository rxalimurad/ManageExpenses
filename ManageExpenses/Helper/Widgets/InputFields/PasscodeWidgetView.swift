//
//  PasscodeWidgetView.swift
//  ManageExpenses
//
//  Created by murad on 14/10/2022.
//

import SwiftUI
import Introspect

public struct PasscodeWidgetView: View {
    
    let maxDigits: Int = 6
    
    @State var pin: String = ""
    @State var isDisabled = false
    @State var shake = false
    @Binding var validPin: String
    @State var color = CustomColor.baseLight_20
    public var body: some View {
        VStack(spacing: 5) {
            ZStack {
                pinDots
                backgroundField
            }
        }
        
    }
    
    private var pinDots: some View {
        HStack(spacing: 10) {
            ForEach(0 ..< maxDigits) { index in
                self.getImageName(at: index)
                    .frame(width: 20, height: 20)
            }
            
        } .transition(.slide)
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
            .introspectTextField { textField in
                textField.becomeFirstResponder()
            }
            .disabled(isDisabled)
    }
    
    
    private func submitPin() {
        guard !pin.isEmpty else {
            return
        }
        
        if pin.count == maxDigits {
            isDisabled = true
            validate()
        } else {
            color = CustomColor.baseLight_20
        }
        
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    func validate() {
        pin = ""
        isDisabled = false
        if pin != validPin {
            color = .red
            withAnimation {
                shake.toggle()
            }
        } else {
            color = .green
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
        )
    }
}

