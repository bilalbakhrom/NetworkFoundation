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
}

extension ServiceProtocol {
    /// Sends a network request and decodes the response into the specified type.
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - router: The router defining the request details.
    /// - Returns: A value of the specified type, representing the decoded response.
    /// - Throws: An error if the request or decoding fails.
    public func request<T: Decodable>(_ type: T.Type, from router: Router) async throws -> T {
        let request = try router.asURLRequest()
        return try await sendRequest(T.self, request: request)
    }
    
    /// Sends the actual network request and handles the response.
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - request: The request to send.
    /// - Returns: A value of the specified type, representing the decoded response.
    /// - Throws: An error if the request or decoding fails.
    private func sendRequest<T: Decodable>(_ type: T.Type, request: URLRequest) async throws -> T {
        // Fetch data.
        let (data, response) = try await fetchData(for: request)
        
        // Log network details.
        if NFSettings.current.showsDebugOnConsole {
            NFLog.log(request: request, response: response, data: data)
        }
        
        // Validate response.
        let checkedData = try validateData(data, withResponse: response)
        
        // Decode response.
        let decodedData = try decodeData(checkedData, as: T.self)
        
        return decodedData
    }
    
    /// Fetches the data for the given request asynchronously.
    /// - Parameter request: The request to fetch data for.
    /// - Returns: A tuple containing the fetched data and the URL response.
    /// - Throws: An error if the data retrieval fails.
    private func fetchData(for request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw NFError.networkError(description: "Failed to fetch data: \(error)")
        }
    }
    
    /// Validates the received data and response.
    /// - Parameters:
    ///   - data: The data to validate.
    ///   - response: The response to validate.
    /// - Returns: The validated data.
    /// - Throws: An error if the validation fails.
    private func validateData(_ data: Data, withResponse response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NFError.failure(description: "Couldn't cast URLResponse to HTTPURLResponse.")
        }
        
        try validateStatusCode(httpResponse.statusCode)
        
        return data
    }
    
    /// Validates the provided status code.
    /// - Parameter statusCode: The status code to validate.
    /// - Throws: An error if the status code is not within the expected range.
    private func validateStatusCode(_ statusCode: Int) throws {
        guard (200..<300).contains(statusCode) else {
            throw NFError.badStatusCode(code: statusCode, description: "Please check your request.")
        }
    }
    
    /// Decodes the provided data into the specified type.
    /// - Parameters:
    ///   - data: The data to decode.
    ///   - type: The type to decode the data into.
    /// - Returns: A value of the specified type, representing the decoded data.
    /// - Throws: An error if the decoding fails.
    private func decodeData<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NFError.decodingError(description: "Failed to decode data: \(error)")
        }
    }
}
