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
    var minLength: Int = 1
    var regex: String = ""
    var isSecure: Bool = false
}
struct InputWidgetView: View {
    @State var isSecured = false
    @State var isErrorShowing = false
    @State var errorMsg = ""
    @Binding var isValidField: Bool
    
    let hint: String
    var properties: InputProperties
    @Binding var text: String
    
    init(hint: String, properties: InputProperties, text: Binding<String>, isValidField: Binding<Bool>) {
        isSecured = properties.isSecure
        self.hint = hint
        self.properties = properties
        self._text = text
        self._isValidField = isValidField
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                Group {
                    if properties.isSecure && isSecured {
                        SecureField(hint, text: $text)
                    } else {
                        TextField(hint, text: $text)
                    }
                    
                }
                if properties.isSecure {
                    Button(action: {
                        isSecured.toggle()
                    }) {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                            .accentColor(.gray)
                    }
                }
                
                
                
                
            }.onReceive(Just(text), perform: { _ in
                DispatchQueue.main.async {
                    if !text.isEmpty {
                        withAnimation {
                            isErrorShowing = !validate()
                        }
                    }
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
                .foregroundColor(.red).isShowing(isErrorShowing)
                .padding([.leading], 16)
        }
        
        
        
    }
    func validate() -> Bool {
        if text.isEmpty {
            errorMsg = "Please enter \(hint)"
            isValidField = true
            return false
        } else {
            if text.count < properties.minLength {
                errorMsg = "\(hint) length should be atleast \(properties.minLength)"
                isValidField = false
                return false
            } else if text.count > properties.maxLength {
                errorMsg = "\(hint) length should be maximum \(properties.maxLength)"
                isValidField = false
                return false
            } else if !properties.regex.isEmpty && !text.vaidateRegex(regex: properties.regex) {
                errorMsg = "Please enter valid \(hint) "
                isValidField = false
                return false
            }
        }
        isValidField = true
        return true
        
    }
}




struct InputWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        InputWidgetView(hint: "Email", properties: InputProperties(maxLength: 10, minLength: 0, regex: ".*"), text: .constant("3434"), isValidField: .constant(true)).padding()
    }
}
