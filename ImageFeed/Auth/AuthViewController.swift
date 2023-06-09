//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 04.06.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    private let identifierToWebVC = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifierToWebVC {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(identifierToWebVC)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(_vc: self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
