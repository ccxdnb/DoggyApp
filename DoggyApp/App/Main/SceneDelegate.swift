//
//  SceneDelegate.swift
//  DoggyApp
//
//  Created by Joaquin Wilson on
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var dependencies = AppDependency()
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator(window: window,
                                            dependencies: dependencies)
        appCoordinator.start()

        self.appCoordinator = appCoordinator
        window.makeKeyAndVisible()
    }
    
}

