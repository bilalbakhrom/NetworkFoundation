//
//  NFSettings.swift
//  
//
//  Created by Bilal Bakhrom on 2023-06-06.
//

import Foundation

final public class NFSettings {
    public static var current = NFSettings()
    
    public var showsDebugOnConsole: Bool = true
    
    // MARK: - REQUEST CONFIGURATION
    
    public var timeoutInterval: TimeInterval = 30
    
    // MARK: - ENCODING CONFIGURATION
    
    public var httpBodyEncoderType: HTTPBodyEncoderType = .default

    public let arrayEncoding: URLEncoder.ArrayEncoding = .brackets

    public let boolEncoding: URLEncoder.BoolEncoding = .numeric
    
    // MARK: - INITIALIZATION
        
    private init() {}
}
