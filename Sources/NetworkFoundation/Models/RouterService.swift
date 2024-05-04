//
//  RouterService.swift
//
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

open class RouterService<R: RouterProtocol>: ServiceProtocol {
    public typealias Router = R
    public let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - REQUEST CONTROL
    
    @discardableResult
    public func requestData(from router: Router) async throws -> Data {
        // Convert the router into a URLRequest.
        let request = try router.asURLRequest()
        
        // Use the sendRequest function to handle the asynchronous request and data retrieval.
        return try await sendRequest(request: request)
    }
    
    public func request<T: Decodable>(_ type: T.Type, from router: Router) async throws -> T {
        // Convert the router into a URLRequest.
        let request = try router.asURLRequest()
        
        // Use the sendRequest function to handle the asynchronous request and data retrieval.
        return try await sendRequest(T.self, request: request)
    }
    
    
    public func request<T: Decodable, E: Decodable>(_ type: T.Type, errorType: E.Type, from router: Router) async throws -> T {
        // Convert the router into a URLRequest.
        let request = try router.asURLRequest()
        
        // Use the sendRequest function to handle the asynchronous request and data retrieval.
        return try await sendRequest(T.self, errorType: errorType, request: request)
    }
    
    
    /// Sends a URLRequest asynchronously and returns the received data.
    ///
    /// - Parameters:
    ///   - request: The URLRequest to be sent.
    ///
    /// - Returns: The data received from the request.
    ///
    /// - Throws: An error if there is any issue during the network request or data validation.
    private func sendRequest(request: URLRequest) async throws -> Data {
        // Fetch data.
        let (data, response) = try await fetchData(for: request)
        
        // Log network details.
        if NFSettings.shared.isDebugModeEnabled {
            NFLog.log(request: request, response: response, data: data)
        }
        
        return try validateResponseData(data, response: response)
    }
    
    /// Sends the actual network request and handles the response.
    ///
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - request: The request to send.
    ///
    /// - Returns: A value of the specified type, representing the decoded response.
    ///
    /// - Throws: An error if the request or decoding fails.
    private func sendRequest<T: Decodable>(_ type: T.Type, request: URLRequest) async throws -> T {
        // Fetch data.
        let (data, response) = try await fetchData(for: request)
        
        // Log network details.
        if NFSettings.shared.isDebugModeEnabled {
            NFLog.log(request: request, response: response, data: data)
        }
        
        // Validate response.
        let checkedData = try validateResponseData(data, response: response)
        
        // Decode response.
        let decodedData = try NFJSONDecoder().decodeData(checkedData, as: type)
        
        return decodedData
    }
    
    /// Sends the actual network request and handles the response.
    ///
    /// - Parameters:
    ///   - type: The type to decode the response into.
    ///   - errorType: The error type to decode the response into.
    ///   - request: The request to send.
    ///
    /// - Returns: A value of the specified type, representing the decoded response.
    ///
    /// - Throws: An error if the request or decoding fails.
    private func sendRequest<T: Decodable, E: Decodable>(_ type: T.Type, errorType: E.Type, request: URLRequest) async throws -> T {
        // Fetch data.
        let (data, response) = try await fetchData(for: request)
        
        // Log network details.
        if NFSettings.shared.isDebugModeEnabled {
            NFLog.log(request: request, response: response, data: data)
        }
        
        do {
            // Validate response.
            let checkedData = try validateResponseData(data, response: response, errorType: errorType)
            
            // Decode response.
            let decodedData = try NFJSONDecoder().decodeData(checkedData, as: type)
            
            return decodedData
        } catch {
            throw proceseThrowableClientError(data: data, errorType: type)
        }
    }
}

// MARK: - UPLOAD CONTROL

extension RouterService {
    /// Uploads data asynchronously and decodes the response into the specified type.
    ///
    /// This method sends an asynchronous upload request using the provided data and router.
    /// It decodes the response data into the specified type using the `sendUpload` method.
    ///
    /// - Parameters:
    ///   - data: The data to be uploaded.
    ///   - type: The type into which the response data should be decoded.
    ///   - router: The router that defines the details of the network upload request.
    ///
    /// - Returns: The decoded response data of the specified type.
    ///
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
    ///
    /// - Returns: The decoded response data of the specified type.
    ///
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
    ///
    /// - Returns: The decoded response data of the specified type.
    ///
    /// - Throws: An error if there is any issue during the network upload request, data validation, or decoding.
    private func sendUpload<T: Decodable>(data: Data, type: T.Type, request: URLRequest) async throws -> T {
        let (data, response) = try await session.upload(for: request, from: data)
        
        // Log network details.
        if NFSettings.shared.isDebugModeEnabled {
            NFLog.log(request: request, response: response, data: data)
        }
        
        // Validate response.
        let checkedData = try validateResponseData(data, response: response)
        
        // Decode response.
        let decodedData = try NFJSONDecoder().decodeData(checkedData, as: type)
        
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
    ///
    /// - Returns: The decoded response data of the specified type.
    ///
    /// - Throws: An error if there is any issue during the network upload request, data validation, or decoding.
    private func sendUpload<T: Decodable, E: Decodable>(data: Data, _ type: T.Type, errorType: E.Type, request: URLRequest) async throws -> T {
        let (data, response) = try await session.upload(for: request, from: data)
        
        // Log network details.
        if NFSettings.shared.isDebugModeEnabled {
            NFLog.log(request: request, response: response, data: data)
        }
        
        do {
            // Validate response.
            let checkedData = try validateResponseData(data, response: response, errorType: errorType)
            
            // Decode response.
            let decodedData = try NFJSONDecoder().decodeData(checkedData, as: type)
            
            return decodedData
        } catch {
            throw proceseThrowableClientError(data: data, errorType: type)
        }
    }
}

// MARK: - SUPPORT

extension RouterService {
    /// Fetches the data for the given request asynchronously.
    ///
    /// - Parameter request: The request to fetch data for.
    ///
    /// - Returns: A tuple containing the fetched data and the URL response.
    ///
    /// - Throws: An error if the data retrieval fails.
    private func fetchData(for request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw NFError.networkError(description: "Failed to fetch data: \(error)")
        }
    }
    
    /// Validates the received data and response.
    ///
    /// - Parameters:
    ///   - data: The data to validate.
    ///   - response: The response to validate.
    ///   - errorType: The type into which the error response data should be decoded.
    ///
    /// - Returns: The validated data.
    ///
    /// - Throws: An error if the validation fails.
    private func validateResponseData<E: Decodable>(_ data: Data, response: URLResponse, errorType: E.Type) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NFError.failure(description: "Couldn't cast URLResponse to HTTPURLResponse.")
        }
        
        try validateStatusCode(httpResponse.statusCode, with: data, errorType: errorType)
        
        return data
    }
    
    /// Validates the received data and response.
    ///
    /// - Parameters:
    ///   - data: The data to validate.
    ///   - response: The response to validate.
    ///
    /// - Returns: The validated data.
    ///
    /// - Throws: An error if the validation fails.
    private func validateResponseData(_ data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NFError.failure(description: "Couldn't cast URLResponse to HTTPURLResponse.")
        }
        
        try validateStatusCode(httpResponse.statusCode, with: data)
        
        return data
    }
    
    /// Validates the provided status code.
    ///
    /// - Parameters:
    ///   - statusCode: The status code to validate.
    ///   - data: The data to validate.
    ///   - errorType: The type into which the error response data should be decoded.
    ///
    /// - Throws: An error if the status code is not within the expected range.
    private func validateStatusCode<E: Decodable>(_ statusCode: Int, with data: Data, errorType: E.Type) throws {
        switch statusCode {
        case 200..<300:
            return
        case 400..<500:
            throw proceseThrowableClientError(data: data, errorType: errorType)
        case 500..<600:
            throw NFError.serverError
        default:
            throw NFError.unexpectedStatusCode(statusCode: statusCode)
        }
    }
    
    /// Validates the provided status code.
    ///
    /// - Parameters:
    ///   - statusCode: The status code to validate.
    ///   - data: The data to validate.
    ///   - errorType: The type into which the error response data should be decoded.
    ///
    /// - Throws: An error if the status code is not within the expected range.
    private func validateStatusCode(_ statusCode: Int, with data: Data) throws {
        switch statusCode {
        case 200..<300:
            return
        case 400..<500:
            throw NFError.clientErrorData(data: data)
        case 500..<600:
            throw NFError.serverError
        default:
            throw NFError.unexpectedStatusCode(statusCode: statusCode)
        }
    }
    
    /// Processes errors that occur during response handling.
    ///
    /// - Parameters:
    ///   - data: Data received from the server.
    ///   - errorType: The type of error model to decode.
    ///
    /// - Returns: An appropriate error based on the provided data and error model type.
    private func proceseThrowableClientError<E: Decodable>(data: Data, errorType: E.Type?) -> Error {
        do {
            if let errorType {
                // Try decoding the error data into the specified error model type.
                let errorData = try NFJSONDecoder().decodeData(data, as: errorType)
                // If successful, return a client error with the decoded error model.
                return NFError.clientErrorModel(model: errorData)
            } else {
                // If decoding fails, return a client error with the original data.
                return NFError.clientErrorData(data: data)
            }
        } catch {
            // If decoding fails, return a client error with the original data.
            return NFError.clientErrorData(data: data)
        }
    }
}
