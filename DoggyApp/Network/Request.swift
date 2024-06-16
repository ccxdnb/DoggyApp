//
//  Endpoint.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Foundation

struct Request {
    let path: String
    let queryItems: [URLQueryItem] = []
    let headers: [String: Any] = APIConstants.defaultHeaders
    var url: URL {
        var components = URLComponents()
        components.scheme = APIConstants.scheme
        components.host = APIConstants.host
        components.path = APIConstants.basePath + path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }

    var reponseValidRange: ClosedRange<Int> { (200...399) }
}

