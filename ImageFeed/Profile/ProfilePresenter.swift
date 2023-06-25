//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 23.06.2023.
//

import UIKit
import WebKit
import Kingfisher

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateProfileDetails(profile: Profile?)
    func observeAvatarChanges()
    func makeAlert() -> UIAlertController
    func logout()
    func cleanServicesData()
    func getUrlForProfileImage() -> URL?
    var profileService: ProfileService { get }
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let webViewViewController = WebViewViewController()
    private let storageToken = OAuth2TokenStorage()
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        updateProfileDetails(profile: profileService.profile)
        observeAvatarChanges()
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else { return }
        view?.surnameLabel.text = profile.name
        view?.emailLabel.text = profile.loginName
        view?.someTextLabel.text = profile.bio
        view?.configView()
        view?.makeConstraints()
    }
    
    func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
    }
    
    func makeAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Уже",
            message: "Are you sure you want to continue?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.dismiss(animated: true)
        return alert
    }
    
    func logout() {
        storageToken.clearToken()
        WebViewViewController.clean()
        cleanServicesData()
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        tabBarController.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
    
    func getUrlForProfileImage() -> URL? {
        guard  let profileImageURL = ProfileImageService.shared.avatarURL,
               let url = URL(string: profileImageURL)  else { return nil }
        return url
    }
}
