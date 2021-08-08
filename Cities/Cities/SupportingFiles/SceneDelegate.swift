//
//  SceneDelegate.swift
//  Cities
//
//  Created by Евгений Полюбин on 07.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let startViewController = StartViewController.init(style: .insetGrouped)
        let navigationViewController = UINavigationController.init(rootViewController: startViewController)
        let window = UIWindow.init(windowScene: windowScene)
        
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

