//
//  InputWidgetView.swift
//  ManageExpenses
//
//  Created by murad on 12/10/2022.
//

import SwiftUI
import Combine

struct InputProperties {
    var maxLength: Int
    var minLength: Int
    var regex: String = ""
    var isSecure: Bool = false
}
struct InputWidgetView: View {
    let hint: String
    let properties: InputProperties
    @State var isErrorShowing
    = false
    @State var errorMsg = ""
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField(hint, text: $text, onEditingChanged: { _ in
                isErrorShowing = returnTrue()
            }, onCommit: {
                withAnimation {
                    isErrorShowing = validate()
                }
            }).onChange(of: Just(text), perform: { _ in
                DispatchQueue.main.async {
                    isErrorShowing = returnTrue()
                    if text.count > properties.maxLength {
                        text = String(text.prefix(properties.maxLength))
                    }
                }
            })

            
                .font(.system(size: 16))
                .foregroundColor(CustomColor.baseLight_20)
                .frame(height: 32)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 20))
                .overlay( RoundedRectangle(cornerRadius: 16) .stroke(isErrorShowing ? .red : CustomColor.baseLight_60))
            
            Text(errorMsg)
                .font(.system(size: 13))
                .foregroundColor(.red).isHidden(isErrorShowing)
                .padding([.leading], 16)
        }
        
        
    }
    
    func returnTrue() -> Bool {
        return false
    }
    func validate() -> Bool {
        if text.isEmpty {
            errorMsg = "Please enter \(hint)"
            return false
        } else {
            if text.count < properties.minLength {
                errorMsg = "\(hint) length should be atleast \(properties.minLength)"
                return false
            } else if text.count > properties.maxLength {
                errorMsg = "\(hint) length should be maximum \(properties.maxLength)"
                return false
            } else if !properties.regex.isEmpty && !text.vaidateRegex(regex: properties.regex) {
                errorMsg = "Please enter valid \(hint) "
                return false
            }
        }
        
        return true
        
    }
}




struct InputWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        InputWidgetView(hint: "Email", properties: InputProperties(maxLength: 10, minLength: 0, regex: ".*"), text: .constant("3434")).padding()
    }
}
