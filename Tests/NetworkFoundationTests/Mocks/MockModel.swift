//
//  MockModel.swift
//  
//
//  Created by Bilal Bakhrom on 2024-05-04.
//

import Foundation

struct MockModel: Codable {
    let name: String?
    let success: Bool?
}

extension MockModel {    
    func asData() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    static var dummyModel: MockModel {
        MockModel(name: "Test", success: true)
    }
}
