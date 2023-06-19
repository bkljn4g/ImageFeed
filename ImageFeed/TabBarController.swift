//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 17.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        // для создания контроллера, помеченного как Is Initial View Controller, вызываем у UIStoryboard метод instantiateViewController(withIdentifier: "<StoryboardID>"
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
