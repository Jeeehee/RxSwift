//
//  SceneDelegate.swift
//  Rx+MVVM_Practice
//
//  Created by Jihee hwang on 2022/11/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}

