//
//  URLRequest+URLRequestConvertible.swift
//  
//
//  Created by Bilal Bakhrom on 2023-06-01.
//

import Foundation

extension URLRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return self
    }
}
