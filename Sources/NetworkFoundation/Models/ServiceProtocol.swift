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

// MARK: - REQUEST CONTROL

extension ServiceProtocol {
    /// Sends an asynchronous network request using a provided router and returns the received data.
    ///
    /// This function prepares a URLRequest using the provided router and then utilizes the `sendRequest` function
    /// to handle the asynchronous request execution and data retrieval. It is designed to simplify the process
    /// of making network requests and fetching data.
    ///
    /// - Parameter router: The router that defines the details of the network request.
    /// - Returns: The data received from the network request.
    /// - Throws: An error if there is any issue during the network request or data retrieval.
    public func requestData(from router: Router) async throws -> Data {
        // Convert the router into a URLRequest.
        let request = try router.asURLRequest()
        
        // Use the sendRequest function to handle the asynchronous request and data retrieval.
        return try await sendRequest(request: request)
    }
    
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
    
    /// Sends a network request and decodes the response into the specified type.
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - errorType: The error type to decode the response into.
    ///   - router: The router defining the request details.
    /// - Returns: A value of the specified type, representing the decoded response.
    /// - Throws: An error if the request or decoding fails.
    public func request<T: Decodable, E: Decodable>(_ type: T.Type, errorType: E.Type, from router: Router) async throws -> T {
        let request = try router.asURLRequest()
        return try await sendRequest(T.self, errorType: errorType, request: request)
    }
    
    
    /// Sends a URLRequest asynchronously and returns the received data.
    ///
    /// - Parameters:
    ///   - request: The URLRequest to be sent.
    /// - Returns: The data received from the request.
    /// - Throws: An error if there is any issue during the network request or data validation.
    private func sendRequest(request: URLRequest) async throws -> Data {
        // Fetch data.
        let (data, response) = try await fetchData(for: request)
        
        // Log network details.
        if NFSettings.current.showsDebugOnConsole {
            NFLog.log(request: request, response: response, data: data)
        }
        
        // Validate the received data with the associated response.
        let validatedData = try validateData(data, withResponse: response)
        
        return validatedData
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
    
    /// Sends the actual network request and handles the response.
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - errorType: The error type to decode the response into.
    ///   - request: The request to send.
    /// - Returns: A value of the specified type, representing the decoded response.
    /// - Throws: An error if the request or decoding fails.
    private func sendRequest<T: Decodable, E: Decodable>(_ type: T.Type, errorType: E.Type, request: URLRequest) async throws -> T {
        // Fetch data.
        let (data, response) = try await fetchData(for: request)
        
        // Log network details.
        if NFSettings.current.showsDebugOnConsole {
            NFLog.log(request: request, response: response, data: data)
        }
                
        do {
            // Validate response.
            let checkedData = try validateData(data, withResponse: response)
            
            // Decode response.
            let decodedData = try decodeData(checkedData, as: T.self)
            
            return decodedData
        } catch {
            let errorData = try decodeData(data, as: E.self)
            
            throw NFError.decodedError(model: errorData)
        }
    }
}

// MARK: - UPLOAD CONTROL

extension ServiceProtocol {
    /// Uploads data asynchronously and decodes the response into the specified type.
    ///
    /// This method sends an asynchronous upload request using the provided data and router.
    /// It decodes the response data into the specified type using the `sendUpload` method.
    ///
    /// - Parameters:
    ///   - data: The data to be uploaded.
    ///   - type: The type into which the response data should be decoded.
    ///   - router: The router that defines the details of the network upload request.
    /// - Returns: The decoded response data of the specified type.
    /// - Throws: An error if there is any issue during the network upload request or data decoding.
    @discardableResult
    public func requestUpload<T: Decodable>(data: Data, type: T.Type, from router: Router) async throws -> T {
        let request = try router.asURLRequest()
        return try await sendUpload(data: data, type: type, request: request)
    }
    
    /// Uploads data asynchronously and decodes the response into the specified type,
    /// with the ability to handle a separate error type.
    ///
    /// This method sends an asynchronous upload request using the provided data and router.
    /// It decodes the response data into the specified type and handles a separate error type
    /// using the `sendUpload` method.
    ///
    /// - Parameters:
    ///   - data: The data to be uploaded.
    ///   - type: The type into which the response data should be decoded.
    ///   - errorType: The type into which the error response data should be decoded.
    ///   - router: The router that defines the details of the network upload request.
    /// - Returns: The decoded response data of the specified type.
    /// - Throws: An error if there is any issue during the network upload request or data decoding.
    @discardableResult
    public func requestUpload<T: Decodable, E: Decodable>(data: Data, _ type: T.Type, errorType: E.Type, from router: Router) async throws -> T {
        let request = try router.asURLRequest()
        return try await sendUpload(data: data, type, errorType: errorType, request: request)
    }
    
    /// Sends an asynchronous upload request and handles the response data decoding.
    ///
    /// This method sends an asynchronous upload request using the provided data and request.
    /// It logs network details and validates the response before decoding the data into the specified type.
    ///
    /// - Parameters:
    ///   - data: The data to be uploaded.
    ///   - type: The type into which the response data should be decoded.
    ///   - request: The URLRequest for the upload request.
    /// - Returns: The decoded response data of the specified type.
    /// - Throws: An error if there is any issue during the network upload request, data validation, or decoding.
    private func sendUpload<T: Decodable>(data: Data, type: T.Type, request: URLRequest) async throws -> T {
        let (data, response) = try await session.upload(for: request, from: data)

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
    
    /// Sends an asynchronous upload request and handles both success and error response data decoding.
    ///
    /// This method sends an asynchronous upload request using the provided data and request.
    /// It logs network details, validates the response, and decodes the data into the specified type.
    /// If an error occurs during decoding, it attempts to decode the data into a separate error type.
    ///
    /// - Parameters:
    ///   - data: The data to be uploaded.
    ///   - type: The type into which the success response data should be decoded.
    ///   - errorType: The type into which the error response data should be decoded.
    ///   - request: The URLRequest for the upload request.
    /// - Returns: The decoded response data of the specified type.
    /// - Throws: An error if there is any issue during the network upload request, data validation, or decoding.
    private func sendUpload<T: Decodable, E: Decodable>(data: Data, _ type: T.Type, errorType: E.Type, request: URLRequest) async throws -> T {
        let (data, response) = try await session.upload(for: request, from: data)
        
        // Log network details.
        if NFSettings.current.showsDebugOnConsole {
            NFLog.log(request: request, response: response, data: data)
        }
                
        do {
            // Validate response.
            let checkedData = try validateData(data, withResponse: response)
            
            // Decode response.
            let decodedData = try decodeData(checkedData, as: T.self)
            
            return decodedData
        } catch {
            // If decoding into the specified type fails, attempt to decode into the error type.
            let errorData = try decodeData(data, as: E.self)
            throw NFError.decodedError(model: errorData)
        }
    }
}

// MARK: - SUPPORT

extension ServiceProtocol {
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
