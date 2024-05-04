//
//  RouterServiceTests.swift
//
//
//  Created by Bilal Bakhrom on 2024-05-04.
//

import XCTest
@testable import NetworkFoundation

class RouterServiceTests: XCTestCase {
    var routerService: RouterService<MockRouter>!

    override func setUp() {
        super.setUp()
        
        let session = URLSession(mockResponder: MockModelURLResponder.self)
        routerService = RouterService(session: session)
    }

    override func tearDown() {
        routerService = nil
        super.tearDown()
    }

    func testRequestDataSuccess() async throws {
        let expectedData = try MockModelURLResponder.item.asData()
        
        do {
            let data = try await routerService.requestData(from: MockRouter.test)
            
            let expectation = XCTestExpectation(description: "Received expected data")
            
            if data == expectedData {
                expectation.fulfill()
            }
            
            await fulfillment(of: [expectation], timeout: 5)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRequestDataFailure() async throws {
        let session = URLSession(mockResponder: MockErrorURLResponder.self)
        let routerService = RouterService<MockRouter>(session: session)
        
        do {
            _ = try await routerService.requestData(from: MockRouter.test)
            XCTFail("Expected network error not thrown")
        } catch {
            XCTAssertTrue(error is NFError)
        }
    }

    func testRequestDecodableSuccess() async throws {
        let expectedResult = MockModelURLResponder.item
        let result = try await routerService.request(MockModel.self, from: MockRouter.test)
        
        XCTAssertEqual(result.name, expectedResult.name)
    }

    func testRequestDecodableFailure() async throws {
        let session = URLSession(mockResponder: MockErrorURLResponder.self)
        let routerService = RouterService<MockRouter>(session: session)
        
        do {
            _ = try await routerService.request(MockModel.self, from: MockRouter.test)
            XCTFail("Expected decoding error not thrown")
        } catch {
            XCTAssertTrue(error is NFError)
        }
    }

    func testUploadSuccess() async throws {
        let uploadData = "Upload data".data(using: .utf8)!
        let result: MockModel = try await routerService.requestUpload(data: uploadData, type: MockModel.self, from: MockRouter.test)
        
        XCTAssertTrue(result.success!)
    }

    func testUploadFailure() async throws {
        let uploadData = "Upload data".data(using: .utf8)!
        let session = URLSession(mockResponder: MockErrorURLResponder.self)
        let routerService = RouterService<MockRouter>(session: session)
        
        do {
            _ = try await routerService.requestUpload(data: uploadData, type: MockModel.self, from: MockRouter.test)
            XCTFail("Expected server error not thrown")
        } catch {
            print("ERROR: \(type(of: error))")
            XCTAssertTrue(error is NFError)
        }
    }
}
