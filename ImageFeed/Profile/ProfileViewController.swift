//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 18.04.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarImage = makeAvatarImage()
        let userName = makeUserName()
        let nickName = makeNickName()
        let profileDescription = makeProfileDescription()
        let logoutButton = makeLogoutButton()
        
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userName.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nickName.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            nickName.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            profileDescription.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    func makeAvatarImage() -> UIImageView { // добавляем аватарку юзера
        let avatarImage = UIImageView(image: UIImage(named: "avatar_image"))
        view.addSubview(avatarImage)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        return avatarImage
    }
    
    func makeUserName() -> UILabel { // добавляем имя юзера
        let userName = UILabel()
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.text = "Ann Goncharova"
        userName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        userName.textColor = .ypWhite
        
        return userName
    }
    
    func makeNickName() -> UILabel { // добавляем никнейм
        let nickName = UILabel()
        view.addSubview(nickName)
        nickName.translatesAutoresizingMaskIntoConstraints = false
        nickName.text = "@goncharova_ann"
        nickName.textColor = .ypGray
        nickName.font = UIFont.systemFont(ofSize: 13)
        
        return nickName
    }
    
    func makeProfileDescription() -> UILabel { // добавляем описание профиля
        let profileDescription = UILabel()
        view.addSubview(profileDescription)
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        profileDescription.text = "Hello, World!"
        profileDescription.textColor = .ypWhite
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        
        return profileDescription
    }
    
    
    func makeLogoutButton() -> UIButton { // добавляем кнопку логаута
        let logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button") ?? UIImage(), target: self, action: nil)
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        //logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.tintColor = .ypRed
        
        return logoutButton
    }
    
    private func updateAvatar() {
        view.backgroundColor = .ypBlack
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        makeAvatarImage().kf.indicatorType = .activity
        makeAvatarImage().kf.setImage(with: url, placeholder: UIImage(named: "avatar_image"), options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    
    private func updateProfileDetails() {
        makeUserName().text = profileService.profile?.name
        makeNickName().text = profileService.profile?.loginName
        makeProfileDescription().text = profileService.profile?.bio
        
    }
}

