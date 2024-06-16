//
//  BreedListViewModel.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import Foundation

class BreedListviewModel {

    @Published var breeds: [String: [String]] = [:]

    private var subscriptions = Set<AnyCancellable>()
    private let service: DogServiceProtocol
    private let coordinator: BreedCoordinatorProtocol

    init(service: DogServiceProtocol, coordinator: BreedCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }

    deinit {
        subscriptions.removeAll()
    }

    func didSelect(breed: String, subBreed: String? = nil) {
        coordinator.goToBreedPicturesBy(breed: breed, subBreed: subBreed)
    }

    func didPressFavoritePictures() {
        coordinator.goToFavPictures()
    }

    func fetchBreeds() {
        self.service.getBreedList()
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }

    func fetchRandomImageFrom(breed: String, and subBreed: String? = nil, onReceiveValue: @escaping (PictureResponse) -> Void) {
        self.service.getRandomPictureBy(breed: breed, subBreed: subBreed)
            .sink(receiveCompletion: onReceive, receiveValue: onReceiveValue)
            .store(in: &subscriptions)
    }

    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(_):
            break
        }
    }

    private func onReceive(_ response: BreedListResponse) {
        self.breeds = response.message
    }
}
