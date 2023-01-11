//
//  GifImage.swift
//  Thesis-Connex
//
//  Created by Jason Lauwrin on 11/01/23.
//
import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable{
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        
        webView.load(data,
                     mimeType: "image/gif",
                     characterEncodingName: "UTF-8",
                     baseURL: url.deletingLastPathComponent())
        
        webView.backgroundColor = .clear
        
        webView.scrollView.backgroundColor = .clear
        
        
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

struct GifImage_Previews: PreviewProvider{
    static var previews: some View{
        GifImage(name: "gif2")
    }
}

