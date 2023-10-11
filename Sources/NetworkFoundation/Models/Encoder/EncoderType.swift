//
//  EncoderType.swift
//
//
//  Created by Bilal Bakhrom on 2023-10-11.
//

import Foundation

/// An enumeration that defines different types of encoders for the `httpBody` parameter of a `URLRequest`.
public enum EncoderType {
    /// Uses a custom implementation of `URLEncoder` to encode the `httpBody` parameter of the `URLRequest`.
    /// 
    /// This encoder is designed for encoding data into a URL-encoded format for the HTTP request body.
    case `default`

    /// Uses the built-in `JSONEncoder` to encode the `httpBody` parameter of the `URLRequest` in JSON format. This encoder is suitable for encoding data into JSON format for the HTTP request body.
    case json
}

