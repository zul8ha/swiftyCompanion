//
//  KeyValueStorageTests.swift
//  swifty_companionTests
//
//  Created by Zuleykha Pavlichenkova on 30.07.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

@testable import swifty_companion
import XCTest

class KeyValueStorageTests: XCTestCase {
    
    var keyValueStorage: KeyValueStorage!
    
    override func setUpWithError() throws {
        keyValueStorage = KeyValueStorage()
    }

    override func tearDownWithError() throws {
        keyValueStorage = nil
    }
    
    func test_setGet() {
        let value = "value"
        let key = "key"
        keyValueStorage.set(value, for: key)
        XCTAssertEqual(keyValueStorage.get(valueFor: key), value)
    }
}
