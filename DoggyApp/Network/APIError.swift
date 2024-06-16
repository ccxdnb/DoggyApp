//
//  APIError.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidServerResponse
    case parseError(Error? = nil, String? = "There was an error parsing the data.")
    case responseError

    // Fall under 400..499
    case badRequest(Error? = nil, String? = "Invalid request")
    case unAuthorised(Error? = nil, String? = "Unautorised request, Please login.")
    case notFound(Error? = nil, String? = "Data not found, Please retry after some time.") 
    case invalidResponse(Error? = nil, String? = "Invalid response. Please retry after some time.")
    case conflictError(Error? = nil, String? = "Already exist.")

    // 500 & above
    case serverError(Error? = nil, String? = "Services are down, Please retry after some time.")

    // Some unknown Error
    case unknown(Error? = nil, String? = "Some error occured, Please try again.")

    // Some Error
    case some(Error? = nil, String? = "Some error occured, Please try again.")


    var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "Invalid Server Response"
        case .parseError(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .responseError:
            return "Response Data Error"
        case .badRequest(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .unAuthorised(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .notFound(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .invalidResponse(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .conflictError(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .serverError(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .unknown(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        case .some(let error, let errorMessage):
            return error?.localizedDescription ?? errorMessage
        }
    }
}
