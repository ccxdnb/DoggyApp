//
//  FavoritePicturesViewModelTests.swift
//  DoggyAppTests
//
//  Created by Joaquin Wilson.
//

import XCTest
import Combine
final class FavoritePicturesViewModelTests: XCTestCase {
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    var sut: FavoritePicturesViewModel!
    var serviceMock: DogServiceMock!

    override func tearDown() {
        subscriptions.removeAll()
        sut = nil
        serviceMock = nil
    }

    override func setUp() {
        serviceMock = .init()
        AppStorage.store(["breed": ["picture"]], for: .likedPictures)
        self.sut = .init(service: serviceMock)
    }

    func testGetFetchPictures() {
        let expectedResponse = DogPicture(breed: "breed", imageURLString: "picture")

        sut.$filteredPictures
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

    func testEmptySearchPictures() {

        sut.$filteredPictures
            .dropFirst(1)
            .sink(receiveCompletion: { completion in
                XCTFail()
            }, receiveValue: { pictures in
                XCTAssertTrue(pictures.isEmpty)
            }
        ).store(in: &subscriptions)

        sut.didSearchBreedWith(query: "some")
    }

    func testSearchPictures() {
        AppStorage.store(["otherBreed": ["otherPicture"]], for: .likedPictures)
        sut.fetchPictures()
        let expectedResponse = DogPicture(breed: "otherBreed", imageURLString: "otherPicture")

        sut.$filteredPictures
            .dropFirst(2)
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

        sut.didSearchBreedWith(query: "otherBreed")
    }
}
