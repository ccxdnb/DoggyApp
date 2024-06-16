//
//  BreedService.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine

protocol DogServiceProtocol {
    func getBreedList() -> AnyPublisher<BreedListResponse, Error>
    func getAllPicturesBy(breed: String, subBreed: String?) -> AnyPublisher<PicturesResponse, Error>
    func getPicturesBy(breed: String, amount: Int) -> AnyPublisher<PicturesResponse, Error>
    func getRandomPictureBy(breed: String, subBreed: String?) -> AnyPublisher<PictureResponse, Error>
}

class DogService: DogServiceProtocol {
    let network: NetworkClient

    init(network: NetworkClient = NetworkClient()) {
        self.network = network
    }

    func getBreedList() -> AnyPublisher<BreedListResponse, Error> {
        let endpoint = DogAPI.breedList
        return network.execute(request: endpoint.request).eraseToAnyPublisher()
    }

    func getAllPicturesBy(breed: String, subBreed: String?) -> AnyPublisher<PicturesResponse, Error> {
        let endpoint = DogAPI.allPicturesBy(breed: breed, subBreed: subBreed)
        return network.execute(request: endpoint.request).eraseToAnyPublisher()
    }

    func getPicturesBy(breed: String, amount: Int) -> AnyPublisher<PicturesResponse, Error> {
        let endpoint = DogAPI.picturesBy(breed: breed, amount: amount)
        return network.execute(request: endpoint.request).eraseToAnyPublisher()
    }

    func getRandomPictureBy(breed: String, subBreed: String? = nil) -> AnyPublisher<PictureResponse, Error> {
        let endpoint = DogAPI.randomPictureBy(breed: breed, subBreed: subBreed)
        return network.execute(request: endpoint.request).eraseToAnyPublisher()
    }
}
