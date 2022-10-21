//
//  KeyboardWidget.swift
//  ManageExpenses
//
//  Created by Ali Murad on 19/10/2022.
//

import SwiftUI

struct KeyboardWidget: View {
    
    var geometry: GeometryProxy
    @Binding var amount: String
    @State private var amountState: String = ""
    @Binding var isShowing : Bool
    @State private var pAmount = ""
    @State private var offset = CGSize(width: 0, height: 0)
    var body: some View {
        VStack {
        
            if isShowing {
                VStack {
                    Text("Enter Amount")
                        .padding([.top], 35)
                        .font(.system(size: 14, weight: .regular))
                    ZStack(alignment: .bottom) {
                        Group {
                            Text("0")
                                .isShowing(amountState.isEmpty)
                                .foregroundColor(.gray.opacity(0.4))
                            Text($amountState.wrappedValue)
                                .isShowing(!amountState.isEmpty)
                        }
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40, weight: .bold))
                        .padding([.top], 5)
                        .padding([.bottom], 10)
                        Divider()
                            .frame(height: 1)
                            .background(Color.gray)
                    }
                    .padding([.horizontal, .bottom], 0)
                    KeyboardView(amount: $amountState)
                        .padding([.top], 40)
                        .padding([.bottom], 20)
                        .padding([.horizontal], 20)
                    ButtonWidgetView(title: "Done", style: .primaryButton) {
                        withAnimation{
                            isShowing.toggle()
                            amount = amountState
                        }
                    }.padding([.bottom], 30)
                    
                    Button {
                        withAnimation{
                         
                            isShowing.toggle()
                        }
                    } label: {
                        Image.Custom.plus.rotationEffect(Angle(degrees: 45))
                            .font(.system(size: 30))
                            .foregroundColor(CustomColor.baseDark)
                        
                    }
                    .padding([.bottom], abs(geometry.safeAreaInsets.bottom))
                    
                    
                }.padding(.horizontal, 40)
                    .background(
                        RoundedCorner(radius: 30)
                            .foregroundColor(CustomColor.keyboardBg)
                    )
                    .foregroundColor(CustomColor.baseDark_50)
                    .transition(.move(edge: .bottom))
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                if gesture.translation.height > 0 {
                                    offset = CGSize(width: 0, height: gesture.translation.height)
                                }
                                if gesture.translation.height > geometry.size.height * 0.2 {
                                    withAnimation{
                                        isShowing = false
                                    }
                                }
                            })
                            .onEnded({ gesture in
                                withAnimation {
                                    offset = CGSize(width: 0, height: 0)
                                }
                            })
                    )
            }
        }
        .padding([.top], geometry.size.height * 0.25)
        .onAppear() {
            offset = CGSize(width: 0, height: 0)
            amountState = amount
        }
    }
}
