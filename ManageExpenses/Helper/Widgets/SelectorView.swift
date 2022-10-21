//
//  SelectorView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 21/10/2022.
//

import SwiftUI

struct NumberPicker: View {
    @Binding var selection: Int
    @Binding var isShowing: Bool
    var body: some View {
        VStack {
            Text("One")
            Text("Two")
            Text("Three")
            Text("Four")
            Text("Five")
        }
    }
}
