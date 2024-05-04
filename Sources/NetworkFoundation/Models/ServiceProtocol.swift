//
//  ServiceProtocol.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

/// A protocol defining a service contract for making network requests.
public protocol ServiceProtocol {
    associatedtype Router: RouterProtocol
    
    var session: URLSession { get }
    
    /// Sends an asynchronous network request using a provided router and returns the received data.
    ///
    /// This function prepares a URLRequest using the provided router and then utilizes the `sendRequest` function
    /// to handle the asynchronous request execution and data retrieval. It is designed to simplify the process
    /// of making network requests and fetching data.
    ///
    /// - Parameter router: The router that defines the details of the network request.
    /// - Returns: The data received from the network request.
    /// - Throws: An error if there is any issue during the network request or data retrieval.
    @discardableResult func requestData(from router: Router) async throws -> Data
    
    /// Sends a network request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - router: The router defining the request details.
    ///
    /// - Returns: A value of the specified type, representing the decoded response.
    ///
    /// - Throws: An error if the request or decoding fails.
    func request<T: Decodable>(_ type: T.Type, from router: Router) async throws -> T
    
    /// Sends a network request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - errorType: The error type to decode the response into.
    ///   - router: The router defining the request details.
    ///
    /// - Returns: A value of the specified type, representing the decoded response.
    ///
    /// - Throws: An error if the request or decoding fails.
    func request<T: Decodable, E: Decodable>(_ type: T.Type, errorType: E.Type, from router: Router) async throws -> T
}
