//
//  BreedPicturesViewModelTests.swift
//  DoggyAppTests
//
//  Created by Joaquin Wilson.
//

import XCTest
import Combine

final class BreedPicturesViewModelTests: XCTestCase {
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    var sut: BreedPicturesViewModel!
    var serviceMock: DogServiceMock!

    override func tearDown() {
        subscriptions.removeAll()
        sut = nil
        serviceMock = nil
    }

    override func setUp() {
        serviceMock = .init()
        self.sut = .init(service: serviceMock, breed: "DogBreed")
    }

    func testFetchPictures() {
        let expectedResponse = DogPicture(breed: "DogBreed", imageURLString: "allPicturesByBreed")

        sut.$pictures
            .dropFirst(1)
            .sink(receiveCompletion: { completion in
                XCTFail()
            }, receiveValue: { pictures in
                XCTAssert(
                    pictures.contains {
                        $0.breed == expectedResponse.breed &&
                        $0.imageURLString == expectedResponse.imageURLString
                    }
                )
            }
        ).store(in: &subscriptions)


        sut.fetchPictures()
    }
}
