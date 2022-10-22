//
//  ColoredView.swift
//  ManageExpenses
//
//  Created by murad on 22/10/2022.
//

import SwiftUI
struct ColoredView: UIViewRepresentable {
    var color: Color
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(color)
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
