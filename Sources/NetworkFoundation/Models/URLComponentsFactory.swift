//
//  URLComponentsFactory.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

internal struct URLComponentsFactory {
    /**
        Creates URLComponents based on the provided host and query items.
     
        - Parameters:
            - host: The host string for creating the URLComponents.
            - queryItems: An optional array of URLQueryItem objects to be assigned to the created URLComponents.
     
        - Throws:
            - NFError.hostError: If the provided host string is empty or If the URLComponents couldn't be created with the given host.
     
        - Returns: A URLComponents object with the specified host and query items.
    */
    internal func create(from host: String, queryItems: [URLQueryItem]?) throws -> URLComponents {
        if host.isEmpty {
            throw NFError.hostError(description: "No host is found.")
        }
        
        var components = URLComponents(string: host)
        components?.queryItems = queryItems
        
        if let components {
            return components
        }
        
        throw NFError.hostError(description: "Couldn't create URLComponents with host: \(host)")
    }
    
    /**
        Creates URLComponents based on the provided host and query items.
     
        - Parameters:
            - host: The host string for creating the URLComponents.
            - queryItems: An optional dictionary of [String: Any] objects to be assigned to the created URLComponents.
     
        - Throws:
            - NFError.hostError: If the provided host string is empty or If the URLComponents couldn't be created with the given host.
     
        - Returns: A URLComponents object with the specified host and query items.
    */
    internal func create(from host: String, queryItems: [String: Any]?) throws -> URLComponents {
        if host.isEmpty {
            throw NFError.hostError(description: "No host is found.")
        }
        
        var components = URLComponents(string: host)
        components?.queryItems = queryItems?.toURLQueryItems
        
        if let components {
            return components
        }
        
        throw NFError.hostError(description: "Couldn't create URLComponents with host: \(host)")
    }
    
    /**
        Creates a URL by appending a path component to the base URL of the provided URLComponents.

        - Parameters:
            - components: The URLComponents object representing the base URL.
            - path: The path component to append to the base URL.

        - Throws:
            - NFError.hostError: If the base URL is missing in the URLComponents.

        - Returns: The URL created by appending the path component to the base URL.

        - Note: This method assumes that the base URL in the URLComponents is valid and well-formed. If the base URL is missing, an error is thrown.
    */
    internal func createURL(from components: URLComponents, byAppendingPathComponent path: String) throws -> URL {
        guard let url = components.url else {
            throw NFError.hostError(description: "Base URL is missing in URLComponents.")
        }
        
        return url.appendingPathComponent(path)
    }
}
