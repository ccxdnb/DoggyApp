//
//  FavoritePicturesViewModel.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine

class FavoritePicturesViewModel {
    @Published var filteredPictures: [DogPicture] = []

    private var pictures: [DogPicture] {
        didSet {
            self.filteredPictures = pictures
        }
    }

    private var subscriptions = Set<AnyCancellable>()

    var service: DogServiceProtocol

    init(service: DogServiceProtocol) {
        self.service = service
        self.pictures = []
    }

    deinit {
        subscriptions.removeAll()
    }

    func fetchPictures(with query: String = "") {
        if let likedPictures: [DogPicture] = AppStorage.data(for: .likedPictures) {
            self.pictures = likedPictures
        }
    }

    func didSearchBreedWith(query: String) {
        if query.isEmpty {
            self.filteredPictures = pictures
            return
        }
        self.filteredPictures = pictures.filter {
            $0.breed.lowercased().range(of: query.lowercased()) != nil
        }
    }
}
