//
//  NFError.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

public enum NFError: Error {
    case hostError(description: String)
    case badStatusCode(code: Int, description: String)
    case networkError(description: String)
    case decodingError(description: String)
    case failure(description: String)
    case decodedError(model: Any)
    case missingURL
}

extension NFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .hostError(let description):
            return "Please check your host. \(description)"
        case .badStatusCode(let code, let description):
            return "Did receive bad status code=\(code) with description=\(description)"
        case .failure(let description):
            return "Did fail with description=\(description)"
        case .networkError(let description):
            return description
        case .decodingError(let description):
            return "Decoding failure: \(description)"
        case .decodedError(let model):
            return "Did decode error: \(model)"
        case .missingURL:
            return "Missing URL"
        }
    }
}
