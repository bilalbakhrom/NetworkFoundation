//
//  Encodable+URLQueryItem.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

extension Encodable {
    public var toURLQueryItems: [URLQueryItem] {
        dictionary.toURLQueryItems
    }
}
