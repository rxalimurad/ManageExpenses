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
    private var action: () -> Void
    
    init(title: String, style: Style, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }.buttonStyle(style)
        
    }
}

struct ButtonWidget_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWidgetView(title: "Continue", style: .primaryButton, action: {})
    }
}
