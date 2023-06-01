//
//  Encodable+Dictionary.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

extension Encodable {
    public subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    public var dictionary: [String: Any] {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            return (jsonObject as? [String: Any]) ?? [:]
        } catch {
            return [:]
        }
    }
}
