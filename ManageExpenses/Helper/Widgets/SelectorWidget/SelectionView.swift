//
//  SelectorView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 21/10/2022.
//

import SwiftUI

struct SelectionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var data: [SelectDataModel]
    var isMultiSelector: Bool
    @Binding var text: SelectDataModel
    var title: String
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CustomColor.baseLight_60
                    .edgesIgnoringSafeArea([.all])
                VStack(spacing: 15) {
                    NavigationBar(title: title, top: 0, titleColor: CustomColor.baseDark, action: {
                        mode.wrappedValue.dismiss()
                    })

                
                    ScrollView {
                        ForEach(0 ..< data.count) { index in
                            Button {
                                for i in 0 ..< data.count {
                                    data[i].isSelected = false
                                }
                                data[index].isSelected.toggle()
                                if !isMultiSelector {
                                    text = data[index]
                                    withAnimation {
                                        mode.wrappedValue.dismiss()
                                    }
                                }
                            } label: {
                                SelectionCell(title: data[index].desc, color: data[index].color, img: data[index].Image,
                                              balance: data[index].balance, isSelected: data[index].isSelected)
                                    .padding([.horizontal], 16)
                            }

                        }
                    }
                    if isMultiSelector {
                        ButtonWidgetView(title: "Done", style: .primaryButton) {
                            mode.wrappedValue.dismiss()
                        }
                        .padding([.horizontal, .top], 16)
                    }
                }
            }
        }
      
    }
}
