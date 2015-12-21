//
//  FileSystemTests.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 04/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import XCTest

class FileSystemTests: XCTestCase {

    
    var testFolder = NSFileManager.defaultManager().cachesURL().URLByAppendingPathComponent("test")
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        cleanCaches()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        cleanCaches()
    }

    
    //MARK: - Utils
    func cleanCaches(){
        
        let fm = NSFileManager.defaultManager()
        if let path = testFolder.path {
            if fm.fileExistsAtPath(path){
                try! fm.removeItemAtURL(testFolder)
            }
        }
        
    }
//    func testCreateFolder(){
//        
//        XCTAssertNoThrows(try createFolder(testFolder))
//        XCTAssertThrows(try createFolder(testFolder))
//        
//        
//    }


}
