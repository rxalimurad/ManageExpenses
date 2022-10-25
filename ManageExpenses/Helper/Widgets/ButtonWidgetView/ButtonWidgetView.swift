//
//  ButtonWidgetView.swift
//  Workout
//
//  Created by Ali Murad on 05/10/2022.
//

import SwiftUI

struct ButtonWidgetView<Style: ButtonStyle>: View {
    private var style: Style
    private var title: String
    private var image: Image?
    private var isDisabled: Bool = false
    private var action: () -> Void
    
    init(title: String, image: Image? = nil, style: Style, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
        self.image = image
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let image = image {
                    image
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding([.leading], 16)
                }
                Text(title)
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
                
        }
        .buttonStyle(style)
            
        
    }
}

struct ButtonWidget_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWidgetView(title: "Continue", style: .primaryButton, action: {})
    }
}
