//
//  RouterService.swift
//  
//
//  Created by Bilal Bakhrom on 2023-05-29.
//

import Foundation

public class RouterService<R: RouterProtocol>: ServiceProtocol {
    public typealias Router = R
    public let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}
