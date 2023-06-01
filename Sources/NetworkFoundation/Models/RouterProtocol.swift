//
//  RouterProtocol.swift
//
//  Created by Bilal Bakhrom on 2023-06-01.
//

import Foundation

public protocol RouterProtocol: URLRequestConvertible {
    /// The HTTP method for the request.
    var method: HTTPMethod { get }
    /// The host of the URL.
    var host: String { get }
    /// The path component of the URL.
    var path: String { get }
    /// The HTTP headers for the request.
    var headers: HTTPHeaders { get }
    /// The parameters to be included in the request's body.
    var bodyParameters: Parameters? { get }
    /// The parameters to be included in the request's URL query string.
    var queryParameters: Parameters? { get }
}

extension RouterProtocol {
    /// The default implementation of the `headers` property, returning `nil`.
    public var headers: HTTPHeaders { return [:] }
    
    /// The default implementation of the `bodyParameters` property, returning `nil`.
    public var bodyParameters: Parameters? { return nil }
    
    /// The default implementation of the `queryParameters` property, returning `nil`.
    public var queryParameters: Parameters? { return nil }
    
    
    /// Default implementation of `asURLRequest` method.
    ///
    /// Creates a `URLRequest` object based on the router's properties, using the provided `URLComponentsFactory` to construct the URL and handle query parameters.
    ///
    /// - Throws: An error if there was an issue creating the `URLRequest`.
    /// - Returns: A `URLRequest` object representing the router's request.
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
