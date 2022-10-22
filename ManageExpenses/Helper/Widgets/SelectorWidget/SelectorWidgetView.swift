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
    @Binding var text: String
    
    init(hint: String, text: Binding<String>) {
        self.hint = hint
        self._text = text
    }
    
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
        
        .popover(isPresented: $showSelection) {
            SelectionView()
        }
        
        
    }
    
    
}

struct SelectorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorWidgetView(hint: ")", text: .constant("0"))
    }
}
