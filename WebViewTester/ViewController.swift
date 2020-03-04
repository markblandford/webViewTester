//
//  ViewController.swift
//  webViewTester
//
//  Created by Mark Blandford on 03/03/2020.
//  Copyright © 2020 Blanmar. All rights reserved.
//
import UIKit
import WebKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView : WKWebView!

    @IBOutlet weak var openUrlButton: UIButton!

    @IBOutlet weak var urlField: UITextField!

    @IBOutlet weak var layoutTextField: NSLayoutConstraint!

    var myActivityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Create Custom ActivityIndicator
        myActivityIndicator.center = self.view.center
        myActivityIndicator.style = .large
        view.addSubview(myActivityIndicator)

        //Adding observer for show loading indicator
        self.webView.addObserver(self, forKeyPath:#keyPath(WKWebView.isLoading), options: .new, context: nil)
    }

    @IBAction func btnLoadUrlAction(_ sender: UIButton) {
        if let urlString = urlField.text {
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
        if keyPath == "loading" {
            if webView.isLoading {
                myActivityIndicator.startAnimating()
                myActivityIndicator.isHidden = false
            } else {
                myActivityIndicator.stopAnimating()
            }
        }
    }
}

extension WKWebView {
    func loadUrl(string: String) {
        if let url = URL(string: string) {
            load(URLRequest(url: url))
        }
    }
}
