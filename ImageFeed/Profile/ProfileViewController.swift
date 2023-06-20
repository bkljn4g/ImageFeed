//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 18.04.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    private let profileImage = UIImageView()
    private let surnameLabel = UILabel()
    private let emailLabel = UILabel()
    private let someTextLabel = UILabel()
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: self, action: #selector(self.didTapButton))
        return exitButton
    }()
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let storageToken = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configView()
        makeConstraints()
        updateProfileDetails(profile: profileService.profile!)
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func configView() {
        view.addSubview(profileImage)
        view.addSubview(surnameLabel)
        view.addSubview(emailLabel)
        view.addSubview(someTextLabel)
        view.addSubview(exitButton)
        
        profileImage.image = UIImage(named: "avatar_image")
        surnameLabel.text = "Ann Goncharova"
        surnameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        surnameLabel.textColor = .ypWhite
        emailLabel.text = "@goncharova_ann"
        emailLabel.font = .systemFont(ofSize: 13)
        emailLabel.textColor = .ypGray
        someTextLabel.text = "11 sprint...must die"
        someTextLabel.font = .systemFont(ofSize: 13)
        someTextLabel.textColor = .ypWhite
        exitButton.setImage(UIImage(named: "logout_button"), for: .normal)
        exitButton.tintColor = .ypRed
        
    }
    
    private func makeConstraints() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        someTextLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            surnameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            surnameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            someTextLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            someTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url,
                                 placeholder: UIImage(named: "avatar_image"),
                                 options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    @objc
    private func didTapButton() {
        showLogoutAlert()
    }
    
    private func logout() {
        storageToken.clearToken()
        WebViewViewController.clean()
        cleanServicesData()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Bye!",
            message: "Are you shure you want to continue?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func cleanServicesData() {
        ImagesListService.shared.clean()
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
    }
}

extension ProfileViewController {
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else { return }
        surnameLabel.text = profile.name
        emailLabel.text = profile.loginName
        someTextLabel.text = profile.bio
    }
}

