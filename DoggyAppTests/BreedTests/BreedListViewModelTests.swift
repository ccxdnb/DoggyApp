//
//  BreedListViewModelTests.swift
//  DoggyAppTests
//
//  Created by Joaquin Wilson.
//

import XCTest
import Combine

final class BreedListViewModelTests: XCTestCase {

    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    var sut: BreedListviewModel!
    var serviceMock: DogServiceMock!
    var coordinatorSpy: BreedCoordinatorSpy!


    override func tearDown() {
        subscriptions.removeAll()
        sut = nil
        serviceMock = nil
    }

    override func setUp() {
        serviceMock = .init()
        coordinatorSpy = .init()
        self.sut = .init(service: serviceMock, coordinator: coordinatorSpy )
    }

    func testGetBreedList() {
        sut.$breeds
            .dropFirst(1)
            .sink(receiveCompletion: { completion in
                XCTFail()
            }, receiveValue: { value in
                XCTAssert(
                    value.contains(where: { (key, value) in
                        key == "some" && value == ["dog"]
                    })
                )
            }
        ).store(in: &subscriptions)
        sut.fetchBreeds()
    }

    func testFetchRandomImageFrom() {
        sut.fetchRandomImageFrom(breed: "breed", onReceiveValue: { picture in
            XCTAssert(picture.message == "randomPicture")
            XCTAssert(picture.status == "OK")
        })}

    func testDidPressPicture() {
        sut.didSelect(breed: "dog", subBreed: "subDog")
        XCTAssert(coordinatorSpy.goToBreedPicturesByPressed)
        XCTAssert(coordinatorSpy.goToBreedPicturesByPressedBreed == "dog")
        XCTAssert(coordinatorSpy.goToBreedPicturesByPressedSubBreed == "subDog")
    }

    func testDidPressFavoritePictures() {
        sut.didPressFavoritePictures()
        XCTAssert(coordinatorSpy.goToFavPicturesPressed)
    }
}
