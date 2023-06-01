//
//  URLRequestConvertible.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

public protocol URLRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    ///
    func asURLRequest() throws -> URLRequest
}
