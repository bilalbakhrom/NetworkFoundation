//
//  Dictionory+URLQueryItem.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    public var toURLQueryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        for (key, value) in self {
            if let items = convertArrayValueToQueryItems(key: key, value: value) {
                queryItems.append(contentsOf: items)
            } else {
                let item = convertSingleValueToQueryItem(key: key, value: value)
                queryItems.append(item)
            }
        }
        
        return queryItems
    }
    
    private func convertSingleValueToQueryItem(key: String, value: Any) -> URLQueryItem {
        let item: URLQueryItem
        
        switch value {
        case let string as String:
            item = URLQueryItem(name: key, value: string)
        case let integer as Int:
            item = URLQueryItem(name: key, value: String(integer))
        case let double as Double:
            item = URLQueryItem(name: key, value: String(double))
        case let float as Float:
            item = URLQueryItem(name: key, value: String(float))
        case let cgFloat as CGFloat:
            item = URLQueryItem(name: key, value: cgFloat.description)
        default:
            item = URLQueryItem(name: key, value: String(describing: value))
        }
        
        return item
    }
    
    private func convertArrayValueToQueryItems(key: String, value: Any) -> [URLQueryItem]? {
        let items: [URLQueryItem]?
        
        switch value {
        case let intVector as [Int]:
            items = intVector.map { URLQueryItem(name: key, value: String($0)) }
        case let stringVector as [String]:
            items = stringVector.map { URLQueryItem(name: key, value: $0) }
        case let doubleVector as [Double]:
            items = doubleVector.map { URLQueryItem(name: key, value: String($0)) }
        case let floatVector as [Float]:
            items = floatVector.map { URLQueryItem(name: key, value: String($0)) }
        default:
            items = nil
        }
        
        return items
    }
}
