//
//  MockURLResponder.swift
//  
//
//  Created by Bilal Bakhrom on 2024-05-04.
//

import Foundation

protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data
}


enum MockModelURLResponder: MockURLResponder {
    static let item: MockModel = {
        return MockModel.dummyModel
    }()
    
    static func respond(to request: URLRequest) throws -> Data {
        return try JSONEncoder().encode(item)
    }
}

enum MockErrorURLResponder: MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data {
        throw URLError(.badServerResponse)
    }
}
