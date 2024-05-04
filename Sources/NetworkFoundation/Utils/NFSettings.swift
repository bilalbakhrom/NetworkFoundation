//
//  NFSettings.swift
//  
//
//  Created by Bilal Bakhrom on 2023-06-06.
//

import Foundation

/// `NFSettings` manages settings for network requests.
public final class NFSettings {
    /// Singleton instance of `NFSettings`.
    public static var shared = NFSettings()
    
    /// Determines whether debug information is shown on console.
    public var isDebugModeEnabled: Bool = true
    
    /// Timeout interval for network requests.
    public var timeoutInterval: TimeInterval = 30
    
    /// Configuration for encoding data in network requests.
    public var encodingConfiguration = EncodingConfiguration()
        
    private init() {}
}

extension NFSettings {
    /// Configuration for encoding data in network requests.
    public struct EncodingConfiguration {
        /// Encoder for HTTP request body.
        public var httpBodyEncoder: HTTPBodyEncoderType = .default

        /// Encoding strategy for arrays.
        public var arrayEncoding: URLEncoder.ArrayEncoding = .brackets

        /// Encoding strategy for booleans.
        public var booleanEncoding: URLEncoder.BoolEncoding = .numeric
    }
}
