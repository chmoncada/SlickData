//
//  BasicStackTests.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 21/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import XCTest

class BasicStackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
     
        let fm = NSFileManager.defaultManager()
        let dbURL = NSBundle.testBundle().bundleURL.URLByAppendingPathComponent("TestModel")
        
        if fm.fileExistsAtPath(dbURL.path!){
            try! fm.removeItemAtURL(dbURL)
        }
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

    func testThatWebURLReturnsNil(){
        let s = BaseSlickDataStack(modelName: "TestModel",
            bundle: NSBundle.testBundle(),
            databaseURL: NSURL(string: "http://www.udacity.com")!)
        XCTAssertNil(s)
    }
    
    func testThatNonExistingURLReturnsNil(){
        
        let s = BaseSlickDataStack(modelName: "TestModel",
            bundle: NSBundle.testBundle(),
            databaseURL: NSURL(string: "file:///xyz")!)
        XCTAssertNil(s)
    }
    
    func testThatCorrectParamsReturnsInstance(){
        
        let s = BaseSlickDataStack(modelName: "TestModel",
            bundle: NSBundle.testBundle(),
            databaseURL: NSBundle.testBundle().bundleURL)
        
        XCTAssertNotNil(s)
    }
    
    
    func testThatDeleteAllDataRemovesTheContainingFolderToo(){
        
        
        let sut = BaseSlickDataStack(modelName: "TestModel",
            bundle: NSBundle.testBundle(),
            databaseURL: NSBundle.testBundle().bundleURL)
        
        
    }
    
}
