//
//  BreedListResponse.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Foundation

struct BreedListResponse: Codable {
    var message: [String: [String]]
    var status: String
}
