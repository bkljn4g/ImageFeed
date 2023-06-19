//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Ann Goncharova on 21.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene) // Создаём окно UIWindow с заданной сценой
        window?.rootViewController = SplashViewController() // Создаём и устанавливаем корневой View Controller для окна. Так как сейчас SplashViewController свёрстан в Storyboard, он создаётся методом instantiateInitialViewController. Если же View полностью сверстать в коде, можно создавать его, используя конструктор по умолчанию SplashViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}
