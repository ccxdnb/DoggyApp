//
//  BreedCoordinatorSpy.swift
//  DoggyAppTests
//
//  Created by Joaquin Wilson.
//

import Foundation

class BreedCoordinatorSpy: BreedCoordinatorProtocol {

    var goToBreedPicturesByPressed: Bool = false
    var goToBreedPicturesByPressedBreed: String = ""
    var goToBreedPicturesByPressedSubBreed: String?

    var goToFavPicturesPressed: Bool = false


    func goToBreedPicturesBy(breed: String, subBreed: String?) {
        self.goToBreedPicturesByPressedBreed = breed
        self.goToBreedPicturesByPressedSubBreed = subBreed
        self.goToBreedPicturesByPressed = true
    }

    func goToFavPictures() {
        self.goToFavPicturesPressed = true
    }


}
