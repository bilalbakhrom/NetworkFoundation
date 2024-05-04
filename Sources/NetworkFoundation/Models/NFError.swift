//
//  NFError.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

public enum NFError: Error {
    case hostError(description: String)
    case unexpectedStatusCode(statusCode: Int)
    case networkError(description: String)
    case decodingError(description: String)
    case failure(description: String)
    case missingURL
    case clientErrorModel(model: Any)
    case clientErrorData(data: Data)
    case serverError
}

extension NFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .hostError(let description):
            return "Please check your host. \(description)"
        case .unexpectedStatusCode(let code):
            return "Did receive bad status code=\(code)"
        case .failure(let description):
            return "Did fail with description=\(description)"
        case .networkError(let description):
            return description
        case .decodingError(let description):
            return "Decoding failure: \(description)"
        case .missingURL:
            return "Missing URL"
        case .clientErrorModel(let model):
            return "Did decode error: \(model)"
        case .clientErrorData(let data):
            return "Did decode error with data: \(data.count) bytes"
        case .serverError:
            return "Something went wrong. Check your server"
        }
    }
}
