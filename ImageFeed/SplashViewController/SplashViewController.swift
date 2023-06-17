//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 08.06.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let splashUIImageView = UIImageView()
    private let alertPresenter = AlertPresenter()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func setUpUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(splashUIImageView)
        splashUIImageView.image = UIImage(named: "Vector")
        splashUIImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            splashUIImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashUIImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashUIImageView.widthAnchor.constraint(equalToConstant: 75),
            splashUIImageView.heightAnchor.constraint(equalToConstant: 77.68)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.fetchProfile(token: token)
            case .failure:
                alertPresenter.showAlert(in: self, with: AlertModel(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    buttonText: "OK", completion: nil),
                                         erorr: Error.self as! Error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.userName else { return }
                    self.profileImageService.fetchProfileImageURL(username: username)  { _ in }
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                }
                UIBlockingProgressHUD.dismiss()
            case .failure:
                alertPresenter.showAlert(in: self, with: AlertModel(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    buttonText: "OK", completion: nil),
                                         erorr: Error.self as! Error)
            }
        }
    }
}
