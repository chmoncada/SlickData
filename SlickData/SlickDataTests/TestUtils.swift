//
//  TestUtils.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 04/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation
import XCTest

// The test bundle (only works if inside the test target)
extension NSBundle{
    
    class func testBundle()->NSBundle{
        class Foo{}     // dummy class
        
        let b = NSBundle(forClass: Foo.self)
        return b
    }
}


extension XCTestCase {
    func XCTAssertThrows(@autoclosure expression: () throws -> Void, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
        XCTAssert((try? expression()) == nil, message, file: file, line: line)
    }
    
    func XCTAssertNoThrows(@autoclosure expression: () throws -> Void, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
        XCTAssertFalse((try? expression()) == nil, message, file: file, line: line)
    }
}