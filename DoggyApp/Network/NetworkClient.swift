//
//  NetworkClient.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import Foundation

final class NetworkClient  {
    static private let decoder: JSONDecoder = .init()

    private let configuration: URLSessionConfiguration
    private let session: URLSession

    init(URLSessionConfiguration: URLSessionConfiguration = .default) {
        self.configuration = URLSessionConfiguration
        self.session = URLSession(configuration: configuration)
    }

    func execute<R: Codable>(request: Request) -> AnyPublisher<R, Error> {
        return session.dataTaskPublisher(for: request.url)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                // response verification
                if let httpResponse = response as? HTTPURLResponse {
                    if request.reponseValidRange.contains(httpResponse.statusCode) {
                        return data
                    } else {
                        throw self.parseError(data: data, response: response)
                    }
                } else {
                    throw APIError.invalidResponse()
                }
            }.tryMap { returnData in
                // decoding
                do {
                    return try NetworkClient.decoder.decode(R.self, from: returnData)
                } catch {
                    throw APIError.parseError(error)
                }
            }.mapError { error in
                //map error to local error protocol
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.unknown(error)
                }

            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    /* later we can implement methods like:
     func upload<R: Codable>(request: Request) -> AnyPublisher<R, Error> {
     return session.uploadTask(with: URLRequest, from: Data)
     }
     */

    private func parseError(data: Data, response: URLResponse) -> Error {
        var errorToReturn: Error?
        if let httpUrlResponse = response as? HTTPURLResponse {

            switch httpUrlResponse.statusCode {
            case 400:
                errorToReturn = APIError.badRequest(errorToReturn)
            case 401:
                errorToReturn = APIError.unAuthorised(errorToReturn)
            case 404:
                errorToReturn = APIError.notFound(errorToReturn)
            case 400...499:
                break
            case 500...599:
                errorToReturn = APIError.serverError()
            default:
                errorToReturn = APIError.unknown()
            }
        }

        return errorToReturn ?? APIError.invalidResponse()
    }
}
