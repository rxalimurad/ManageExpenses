//
//  WebView.swift
//  ManageExpenses
//
//  Created by murad on 13/10/2022.
//

import UIKit
import SwiftUI
import WebKit
struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let type: HTMLType
    
    
    
    func makeUIView(context: Context) -> WKWebView {
        let html = Utilities.getHtml(for: type) ?? ""
        let webView = WKWebView(frame: .zero)
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}