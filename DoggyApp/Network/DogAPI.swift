//
//  DogApi.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Foundation

typealias Breed = String

enum DogAPI {
    case breedList
    case allPicturesBy(breed: Breed, subBreed: Breed?)
    case picturesBy(breed: Breed, amount: Int)
    case randomPictureBy(breed: Breed, subBreed: Breed?)

    var request: Request {
        switch self {
        case .breedList:
            return Request(path: "/breeds/list/all")
        case .allPicturesBy(let breed, let subBreed):
            if let subBreed = subBreed {
                return Request(path: "/breed/\(breed)/\(subBreed)/images")
            } else {
                return Request(path: "/breed/\(breed)/images/")
            }
        case .picturesBy(let breed, let amount):
            return Request(path: "/breed/\(breed)/images/random/\(amount)")
        case .randomPictureBy(let breed, let subBreed):
            if let subBreed = subBreed {
                return Request(path: "/breed/\(breed)/\(subBreed)/images/random/")
            } else {
                return Request(path: "/breed/\(breed)/images/random/")
            }
        }
    }
}
