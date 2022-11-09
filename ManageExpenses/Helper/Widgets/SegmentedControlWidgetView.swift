//
//  SegmentedControlWidgetView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 17/10/2022.
//

import SwiftUI

struct SegmentedControlWidgetView: View {
    
    var items: [String]
   
    @Binding var selectedIndex: Int
    var padding = 8.0
    var fontSize = 14.0
    var textColor = CustomColor.yellow
    var bgColor = CustomColor.yellow_20
    @Namespace var namespace
    
    var body: some View {
        ScrollViewReader { proxy in
            if #available(iOS 15.0, *) {
                    HStack {
                        ForEach(items.indices, id: \.self) { index in
                            Text(items[index])
                                .font(.system(size: fontSize, weight: .bold))
                                .padding(.vertical, padding)
                                .foregroundColor(index == selectedIndex ? textColor : CustomColor.baseLight_20)
                                .frame(maxWidth: .infinity)
                                .matchedGeometryEffect(
                                    id: index,
                                    in: namespace,
                                    isSource: true
                                )
                                .onTapGesture {
                                    withAnimation {
                                        selectedIndex = index
                                        proxy.scrollTo(index)
                                    }
                                }
                           
                        }
                    }
                .padding(padding)
                .background {
                    Capsule()
                        .fill(bgColor)
                        .matchedGeometryEffect(
                            id: selectedIndex,
                            in: namespace,
                            isSource: false
                        )
                }
                
            } else {
                Picker("", selection: $selectedIndex) {
                    ForEach(items.indices, id: \.self) { index in
                        Text(items[index])
                            .font(.system(size: fontSize, weight: .bold))
                            .padding(.vertical, padding)
                            .foregroundColor(index == selectedIndex ? textColor : CustomColor.baseLight_20)
                    }
                }.pickerStyle(.segmented)
            }
        }
    }
    
}

struct SegmentedControlWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControlWidgetView(
            items: ["Years", "Months", "Days", "All Photos"],
            selectedIndex: .constant(1)
        )
    }
}
