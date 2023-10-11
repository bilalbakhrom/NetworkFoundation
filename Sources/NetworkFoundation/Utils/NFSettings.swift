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
    
    public var timeoutInterval: TimeInterval = 30
    
    public var encoderType: EncoderType = .default
        
    public init() {}
}
