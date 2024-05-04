//
//  MockRouter.swift
//  
//
//  Created by Bilal Bakhrom on 2024-05-04.
//

import Foundation
@testable import NetworkFoundation

struct MockRouter: RouterProtocol {
    static var test = MockRouter()
    
    var method: NetworkFoundation.HTTPMethod { .get }
    
    var host: String { "" }
    
    var path: String { "" }

    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: URL(string: "https://example.com")!)
    }
}
