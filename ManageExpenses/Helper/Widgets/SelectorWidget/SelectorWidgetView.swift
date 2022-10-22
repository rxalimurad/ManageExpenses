//
//  SelectorWidgetView.swift
//  ManageExpenses
//
//  Created by murad on 22/10/2022.
//

import SwiftUI

struct SelectorWidgetView: View {
    @State var showSelection = false
    let hint: String
    let isMultiSelector: Bool = false
    @State var text: String
    @Binding var data: [SelectDataModel]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                showSelection.toggle()
            }, label: {
                ZStack(alignment: .trailing) {
                    Group  {
                        Text(text.isEmpty ? hint : text)
                            .foregroundColor(text.isEmpty ? CustomColor.hintColor : CustomColor.baseLight_20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    Image.Custom.downArrow
                    
                }
            })
            
            
            
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
