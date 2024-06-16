//
//  BreedCoordinator.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import UIKit

protocol BreedCoordinatorProtocol {
    func goToBreedPicturesBy(breed: String, subBreed: String?)
    func goToFavPictures()
}

class BreedCoordinator: Coordinator, BreedCoordinatorProtocol {
    typealias Dependencies = HasDogService

    var dependencies: Dependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let viewModel: BreedListviewModel = .init(service: dependencies.dogService, coordinator: self)
        let viewController: BreedListViewController = .init(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: false)
    }

    func goToBreedPicturesBy(breed: String, subBreed: String? = nil) {
        let viewModel: BreedPicturesViewModel = .init(service: dependencies.dogService, breed: breed, subBreed: subBreed)
        let viewController: BreedPicturesViewController = .init(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func goToFavPictures() {
        let viewModel: FavoritePicturesViewModel = .init(service: dependencies.dogService)
        let viewController: FavoritePicturesViewController = .init(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
