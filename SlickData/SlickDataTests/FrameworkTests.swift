//
//  FrameworkTests.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 04/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//
import Foundation
import XCTest

class FrameworkTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func foo() throws{
        throw NSError(domain: "", code: 42, userInfo: nil)
    }
    
    func throwSomething(z: Int?) throws{
        if case .None = z {
            throw NSError(domain: "", code: 42, userInfo: nil)
        }
    
    }
    
    func testOptionalTryOnVoidReturningFunctions(){

        // It should work, because void returning functions actually return
        // () (Void)
        XCTAssertNil(try? foo())
    }
    
    func testAssertThrows(){
        XCTAssertThrows(try foo(), "foo does throw")
        XCTAssertThrows(try throwSomething(nil), "meh")
        XCTAssertNoThrows(try throwSomething(42), "should throw")
    }
    
    

}
