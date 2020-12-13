//
//  StubResponse.swift
//  blockchain-member-app
//
//  Created by YORK CHAN on 14/1/2020.
//  Copyright © 2020 accenture. All rights reserved.
//

import Foundation
import UIKit
import OHHTTPStubs

@testable
import iOSTechnicalTask

class StubResponse {
    
    // MARK: - Properties
    static let shared = StubResponse()

    // Initialization
    private init() {}
    
    func createStub(host: String, path: String, json: String) -> HTTPStubsDescriptor {
        return stub(condition: isHost(host) && isPath(path)) { _ in
            let stubPath = OHPathForFile(json, type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }
    
    func removeStub(stub: HTTPStubsDescriptor) {
        HTTPStubs.removeStub(stub)
    }
}
