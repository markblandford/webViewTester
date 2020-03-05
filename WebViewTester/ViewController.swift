//
//  ViewController.swift
//  webViewTester
//
//  Created by Mark Blandford on 03/03/2020.
//  Copyright © 2020 Blanmar. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate {

    @IBOutlet var webView : WKWebView!

    @IBOutlet weak var openUrlButton: UIButton!

    @IBOutlet weak var urlField: UITextField!

    var progressView = UIProgressView(progressViewStyle: .default)

    deinit {
        webView.removeObserver(self, forKeyPath:#keyPath(WKWebView.estimatedProgress))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.allowsBackForwardNavigationGestures = true

        // progress bar
        progressView.autoresizingMask = [ .flexibleWidth, .flexibleTopMargin ]
        progressView.progressTintColor = UIColor.systemGreen

        progressView.sizeToFit()
        let urlBarView = view.subviews[0].subviews[1]
        urlBarView.addSubview(progressView)

        let bounds = urlBarView.bounds
        progressView.frame = CGRect(x: 0, y: bounds.size.height, width: bounds.size.width, height: 2)

        // observer for loading progress
        webView.addObserver(self, forKeyPath:#keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        webView.navigationDelegate = self
        
        // add the ability to pull-down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
    }

    @IBAction func btnLoadUrlAction(_ sender: UIButton) {
        if let urlString = urlField.text {
            progressView.isHidden = false
            var requestUrl: String

            if urlString.starts(with: "http://") || urlString.starts(with: "https://"){
                requestUrl = urlString
            } else if urlString.isEmpty {
                requestUrl = "https://www.example.com"
            } else {
                requestUrl = "https://\(urlString)"
            }

            webView.loadUrl(string: requestUrl)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc
    func refreshWebView(_ sender: UIRefreshControl) {
        webView?.reload()
        sender.endRefreshing()
    }
}

extension WKWebView {
    func loadUrl(string: String) {
        if let url = URL(string: string) {
            load(URLRequest(url: url))
        }
    }
}
