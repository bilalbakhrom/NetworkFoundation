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
    
    func asURLRequest() throws -> URLRequest
}

// MARK: - OPTIONAL PROPERTIES

extension RouterProtocol {
    /// The default implementation of the `headers` property, returning `nil`.
    public var headers: HTTPHeaders { return [:] }
    
    /// The default implementation of the `bodyParameters` property, returning `nil`.
    public var bodyParameters: Parameters? { return nil }
    
    /// The default implementation of the `queryParameters` property, returning `nil`.
    public var queryParameters: Parameters? { return nil }
}

// MARK: - OPTIONAL METHODS

extension RouterProtocol {
    /// Default implementation of `asURLRequest` method.
    ///
    /// This method creates a `URLRequest` object based on the router's properties. It utilizes the provided `URLComponentsFactory` to construct the URL and handle query parameters.
    ///
    /// - Throws: An error if there was an issue creating the `URLRequest`.
    /// - Returns: A `URLRequest` object representing the router's request.
    public func asURLRequest() throws -> URLRequest {
        // Create URL components with the help of the URLComponentsFactory
        let urlComponentsFactory = URLComponentsFactory()
        let components = try urlComponentsFactory.create(from: host, queryItems: queryParameters)
        
        // Construct the complete URL by appending the path to the base URL
        let url = try urlComponentsFactory.createURL(from: components, byAppendingPathComponent: path)
        
        // Create the URLRequest
        let urlRequest = try createURLRequest(
            from: url,
            headers: headers,
            method: method,
            parameters: bodyParameters,
            settings: NFSettings.current
        )
        
        return urlRequest
    }

    /// Creates a URLRequest with the specified details, including URL, headers, HTTP method, and optional parameters.
    ///
    /// - Parameters:
    ///   - url: The URL for the URLRequest.
    ///   - headers: The headers to be included in the URLRequest.
    ///   - method: The HTTP method for the URLRequest.
    ///   - parameters: Optional parameters to be included in the URLRequest's body.
    ///   - settings: The network settings used for the URLRequest, including timeout interval and encoder type.
    /// - Returns: A URLRequest configured with the provided details.
    /// - Throws: An error if there's an issue in the parameter encoding process.
    private func createURLRequest(
        from url: URL,
        headers: HTTPHeaders,
        method: HTTPMethod,
        parameters: Parameters?,
        settings: NFSettings
    ) throws -> URLRequest {
        // Initialize a URLRequest with the given URL
        var urlRequest = URLRequest(url: url)
        
        // Set HTTP method, headers, and timeout interval based on the provided parameters and settings
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.timeoutInterval = settings.timeoutInterval
        
        // If parameters are provided, encode them into the URLRequest's body
        if let parameters = parameters {
            try encodeParameters(
                parameters,
                with: settings.httpBodyEncoderType,
                for: &urlRequest,
                settings: settings
            )
        }
        
        return urlRequest
    }

    /// Encodes the given parameters into the specified URLRequest based on the provided encoder type and settings.
    ///
    /// - Parameters:
    ///   - parameters: The parameters to be encoded.
    ///   - encoderType: The type of encoder to be used for parameter encoding.
    ///   - urlRequest: The URLRequest to which the encoded parameters will be applied.
    ///   - settings: The network settings used for encoding parameters, such as array and boolean encoding.
    /// - Throws: An error if the encoding process fails.
    private func encodeParameters(
        _ parameters: Parameters,
        with encoderType: HTTPBodyEncoderType,
        for urlRequest: inout URLRequest,
        settings: NFSettings
    ) throws {
        switch encoderType {
        case .default:
            // Use URLEncoder to encode parameters in the HTTP body
            let encoder = URLEncoder(
                destination: .httpBody,
                arrayEncoding: settings.arrayEncoding,
                boolEncoding: settings.boolEncoding
            )
            urlRequest = try encoder.encode(urlRequest, with: parameters)
            
        case .json:
            // Encode parameters in JSON format
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
    }
}
