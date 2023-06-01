//
//  HTTPMethod.swift
//  
//
//  Created by Bilal Bakhrom on 2023-06-01.
//

import Foundation

public enum HTTPMethod: String, CaseIterable, Equatable {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case query = "QUERY"
    case trace = "TRACE"
}
