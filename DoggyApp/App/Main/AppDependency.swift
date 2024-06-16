//
//  AppDependency.swift
//  DoggyApp
//
//  Created by Joaquin Wilson on
//

import Foundation


protocol HasClient {
    var client: NetworkClient { get }
}

protocol HasDogService {
    var dogService: DogServiceProtocol { get }
}

struct AppDependency: HasClient, HasDogService {

    let client: NetworkClient
    let dogService: DogServiceProtocol

    init() {
        self.client = NetworkClient()
        self.dogService = DogService(network: self.client)
    }
}
