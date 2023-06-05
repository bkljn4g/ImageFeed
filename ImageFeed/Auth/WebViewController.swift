//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 04.06.2023.
//

import UIKit
import WebKit

fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewController)
}

final class WebViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    
    weak var delegate: WebViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_time", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        @IBAction func didTapBackButton(_ sender: Any?) { delegate?.webViewViewControllerDidCancel(self) }
        
        
        
    }
}
    
        
extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
        {
        if let code = code(from: navigationAction) {
            //TODO: process code
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
            } else {
            decisionHandler(.allow)
            }
        }
        
        private func code(from navigationAction: WKNavigationAction) -> String? {
            if
                let url = navigationAction.request.url,
                let urlComponents = URLComponents(string: url.absoluteString),
                urlComponents.path == "/oauth/authorize/native",
                let items = urlComponents.queryItems,
                let codeItem = items.first(where: { $0.name == "code"})
            {
                return codeItem.value
            } else {
                return nil
            }
        }
    }
