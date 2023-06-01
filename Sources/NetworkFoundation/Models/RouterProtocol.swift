//
//  RouterProtocol.swift
//
//  Created by Bilal Bakhrom on 2023-06-01.
//

import Foundation

public protocol RouterProtocol: URLRequestConvertible {
    var method: HTTPMethod { get }
    var host: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var bodyParameters: Parameters? { get }
    var queryParameters: Parameters? { get }
}

extension RouterProtocol {
    public var headers: HTTPHeaders { return [:] }
    
    public var bodyParameters: Parameters? { return nil }
    
    public var queryParameters: Parameters? { return nil }
    
    public func asURLRequest() throws -> URLRequest {
        let urlComponentsFactory = URLComponentsFactory()
        let components = try urlComponentsFactory.create(from: host, queryItems: queryParameters)
        let url = try urlComponentsFactory.createURL(from: components, byAppendingPathComponent: path)
        let urlRequest = createURLRequest(from: url, headers: headers, method: method, parameters: bodyParameters)
        
        return urlRequest
    }
    
    /**
        Creates a URLRequest with the provided URL, headers, HTTP method, and optional parameters.

        - Parameters:
            - url: The URL for the URLRequest.
            - headers: The HTTP headers for the URLRequest.
            - method: The HTTP method for the URLRequest.
            - parameters: The optional parameters to include in the URLRequest's body.

        - Returns: The URLRequest object created based on the provided parameters.
    */
    private func createURLRequest(from url: URL, headers: HTTPHeaders, method: HTTPMethod, parameters: Parameters?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.timeoutInterval = 10
        
        if let parameters {
            do {
                let encoder = URLEncoder(destination: .httpBody)
                urlRequest = try encoder.encode(urlRequest, with: parameters)
            } catch {
                print("Couldn't decode http body: \(parameters)")
            }
        }
        
        return urlRequest
    }
}
