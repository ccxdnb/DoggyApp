//
//  AppCoordinator.swift
//  DoggyApp
//
//  Created by Joaquin Wilson on
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    typealias Dependencies = HasDogService

    var dependencies: Dependencies

    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var navigationController: UINavigationController

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.window.tintColor = .orange
        self.navigationController = .init()
        self.dependencies = dependencies
    }

    func start() {
        self.window.rootViewController = navigationController
        let child = BreedCoordinator(navigationController: self.navigationController,
                                     dependencies: dependencies)
        self.childCoordinators.append(child)
        child.start()
    }
}

