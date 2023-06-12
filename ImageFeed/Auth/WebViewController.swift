//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 04.06.2023.
//

import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    
    fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        updateProgress()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    @IBOutlet private var progressView: UIProgressView!
}

extension WebViewViewController: WKNavigationDelegate { // получаем ответ от unsplash в URL -> проверка адреса -> вытаскиваем код авторизации -> передача в веб вью
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }

    func webView(_ webView: WKWebView, // реализация протокола WKNavigationDelegate
         decidePolicyFor navigationAction: WKNavigationAction,
         decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code) // делегирование обработки кода авторизации в AuthViewController
            decisionHandler(.cancel) // код авторизации получен
    } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewViewController { // экстеншн для загрузки веб-контента
    func loadWebView() { // функция передана во вьюдидлоад, переопределение
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)! //инициализация структуры URLComponents с указанием адреса запроса
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey), // установка значения client_id - код доступа приложения
            URLQueryItem(name: "redirect_uri", value: RedirectURI), // URI, который обрабатывает успешную авторизацию пользователя
            URLQueryItem(name: "response_type", value: "code"), // тип ответа: код
            URLQueryItem(name: "scope", value: AccessScope) // область запроса
        ]
        
        guard let url = urlComponents.url else { return print ("no answer from URL")}
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
