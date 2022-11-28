//
//  SelectorWidgetView.swift
//  ManageExpenses
//
//  Created by murad on 22/10/2022.
//

import SwiftUI

struct SelectorWidgetView: View {
    let hint: String
    @Binding var text: SelectDataModel
    @Binding var data: [SelectDataModel]
    
    @State var showSelection = false
    let isMultiSelector: Bool = false
    var disabled: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                showSelection.toggle()
            }, label: {
                ZStack(alignment: .trailing) {
                    Group  {
                        Text(text.desc.isEmpty ? hint : text.desc)
                            .foregroundColor(text.desc.isEmpty ? CustomColor.hintColor : CustomColor.baseLight_20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    Image.Custom.downArrow
                        .isShowing(!disabled)
                    
                }
            }).disabled(disabled)
            
            
            
            .font(.system(size: 16))
            .foregroundColor(CustomColor.baseLight_20)
            .frame(height: 32)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 20))
            .overlay( RoundedRectangle(cornerRadius: 16).stroke(CustomColor.baseLight_60))
            
        }
        .fullScreenCover(isPresented: $showSelection) {
            SelectionView(data: $data, isMultiSelector: isMultiSelector, text: $text, title: hint)
        }
        
        
    }
    
    
}

//struct SelectorWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectorWidgetView(hint: ")", text: .constant("0"))
//    }
//}
