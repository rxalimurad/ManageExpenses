//
//  PasscodeWidgetView.swift
//  ManageExpenses
//
//  Created by murad on 14/10/2022.
//

import SwiftUI

import SwiftUI
public struct PasscodeWidgetView: View {
    
    var maxDigits: Int = 8
    var label = "Enter your Verification Code"
    
    @State var pin: String = ""
    @State var isDisabled = false
    
    
    var handler: ((String, (Bool) -> Void) -> Void)?
    
    public var body: some View {
        VStack(spacing: 29) {
            Text(label)
                .font(.system(size: 38))
                .foregroundColor(CustomColor.baseDark)
            ZStack {
                pinDots
                backgroundField
            }
        }
        
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .font(.system(size: 20, weight: .thin, design: .default))
                Spacer()
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
        .accentColor(.clear)
           .foregroundColor(.clear)
//           .focused(.constant(true))
           .keyboardType(.numberPad)
           .disabled(isDisabled)
    }
    
    
    private func submitPin() {
        guard !pin.isEmpty else {
            return
        }
        
        if pin.count == maxDigits {
            isDisabled = true
            
            handler?(pin) { isSuccess in
                if isSuccess {
                    print("pin matched, go to next page, no action to perfrom here")
                } else {
                    pin = ""
                    isDisabled = false
                    print("this has to called after showing toast why is the failure")
                }
            }
        }

        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "circle"
        }
        return "circle.fill"
    }
}

