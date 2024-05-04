//
//  NFJSONDecoder.swift
//  
//
//  Created by Bilal Bakhrom on 2024-05-04.
//

import Foundation

public struct NFJSONDecoder {
    /// Decodes the provided data into the specified type.
    ///
    /// - Parameters:
    ///   - data: The data to decode.
    ///   - type: The type to decode the data into.
    ///
    /// - Returns: A value of the specified type, representing the decoded data.
    ///
    /// - Throws: An error if the decoding fails.
    public func decodeData<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NFError.decodingError(description: "Failed to decode data: \(error.localizedDescription)")
        }
    }
}
