//
//  DogServiceMock.swift
//  DoggyAppTests
//
//  Created by Joaquin Wilson.
//

import Combine
enum ResponseScenario {
    case success, failure
}

class DogServiceMock: DogServiceProtocol {

    var responseScenario: ResponseScenario = .success

    func getBreedList() -> AnyPublisher<BreedListResponse, Error> {
        return Just(BreedListResponse(message: ["some":["dog"]], status: "OK"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getAllPicturesBy(breed: String, subBreed: String?) -> AnyPublisher<PicturesResponse, Error> {
        return Just(PicturesResponse(message: ["allPicturesByBreed"], status: "OK"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    }

    func getPicturesBy(breed: String, amount: Int) -> AnyPublisher<PicturesResponse, Error> {
        return Just(PicturesResponse(message: ["picturesByBreed"], status: "OK"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    }

    func getRandomPictureBy(breed: String, subBreed: String?) -> AnyPublisher<PictureResponse, Error> {
        return Just(PictureResponse(message: "randomPicture", status: "OK"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

}
