//
//  WebViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 22.01.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - WebView Stack
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView // Замена основного View На WebView
        
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true // Разрешить жесты навигации
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [progressButton, flexibleSpacer, refreshButton]
        navigationController?.isToolbarHidden = false // Не скрывать Toolbar
        
        
        
    }
}
