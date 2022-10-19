//
//  KeyboardWidget.swift
//  ManageExpenses
//
//  Created by Ali Murad on 19/10/2022.
//

import SwiftUI

struct KeyboardWidget: View {
    @Binding var amount: String
    @State private var pAmount = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Enter Amount")
                ZStack(alignment: .bottom) {
                    Group {
                        Text("0")
                            .isShowing(amount.isEmpty)
                            .foregroundColor(.gray.opacity(0.4))
                        Text($amount.wrappedValue)
                            .isShowing(!amount.isEmpty)
                    }
                    .multilineTextAlignment(.center)
                    .font(.system(size: 40, weight: .bold))
                    .padding([.vertical], 5)
                    Divider()
                        .frame(height: 1)
                        .background(Color.red)
                }
                .padding([.horizontal, .bottom], 20)
                KeyboardView(amount: $amount)
                    .frame(height: 256)
                    .padding([.bottom], 20)
                    .padding([.horizontal], 20)
                ButtonWidgetView(title: "Done", style: .primaryButton) {
                    mode.wrappedValue.dismiss()
                }.padding([.bottom], 30)
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.gray.opacity(0.4))
                        Image.Custom.plus.rotationEffect(Angle(degrees: 45))
                            .foregroundColor(CustomColor.baseLight)
                    }.frame(width: 40, height: 40)
                }
                
                
            }
            .foregroundColor(CustomColor.baseDark_50)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .padding(.horizontal, 40)
            
        }
    }
}

struct KeyboardWidget_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardWidget(amount: .constant("52"))
    }
}
