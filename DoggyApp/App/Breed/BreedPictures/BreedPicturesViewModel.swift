//
//  BreedPicturesViewModel.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine

class BreedPicturesViewModel {
    @Published var pictures: [DogPicture] = []
    private var subscriptions = Set<AnyCancellable>()

    var service: DogServiceProtocol
    let breed: String
    let subBreed: String?

    init(service: DogServiceProtocol, breed: String, subBreed: String? = nil) {
        self.service = service
        self.breed = breed
        self.subBreed = subBreed
    }

    deinit {
        subscriptions.removeAll()
    }

    func fetchPictures() {
        self.service.getAllPicturesBy(breed: self.breed, subBreed: self.subBreed)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
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

    private func onReceive(_ response: PicturesResponse) {
        self.pictures = response.message.map { DogPicture(breed: self.breed, imageURLString: $0) }
    }

    func didPressLike(breedName: String, imageURL: String, isLiked: Bool) {
        let dogPicture = DogPicture(breed: self.breed, imageURLString: imageURL)

        if var likedPictures: [DogPicture] = AppStorage.data(for: .likedPictures) {
            if isLiked {
                likedPictures.removeAll(where: { $0.imageURLString == dogPicture.imageURLString })
            } else {
                likedPictures.append(dogPicture)
            }

            AppStorage.store(likedPictures, for: .likedPictures)
        } else {
            AppStorage.store([dogPicture], for: .likedPictures)
        }
    }

    func isImageLiked(with: DogPicture) -> Bool {
        if let likedPictures: [DogPicture] = AppStorage.data(for: .likedPictures) {
            return likedPictures.first { $0.imageURLString == with.imageURLString } != nil
        }
        return false
    }
}
