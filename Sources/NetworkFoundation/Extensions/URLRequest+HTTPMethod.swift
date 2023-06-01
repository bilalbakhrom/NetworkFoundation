//
//  URLRequest+HTTPMethod.swift
//  
//
//  Created by Bilal Bakhrom on 2023-06-01.
//

import Foundation

extension URLRequest {
    /// Returns the `httpMethod` as Alamofire's `HTTPMethod` type.
    public var method: HTTPMethod? {
        get {
            guard let httpMethod else { return nil }
            return HTTPMethod(rawValue: httpMethod)
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}
