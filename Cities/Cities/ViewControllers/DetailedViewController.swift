//
//  DetailedViewController.swift
//  Cities
//
//  Created by Евгений Полюбин on 07.08.2021.
//

import UIKit
import WebKit

class DetailedViewController: UIViewController, WKUIDelegate {
    var url: String!
    weak var webView: WKWebView!
    
    convenience init(url: String) {
        self.init()
        self.url = url
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
            
        self.webView = webView
        self.view = webView
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: URL(string: url)!)
        webView.load(myRequest)
    }
}
