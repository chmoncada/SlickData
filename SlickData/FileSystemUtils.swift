//
//  FileSystemUtils.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 04/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

// creates a folder at a certain URL, as long as it doesn't
// exist previously
func createFolder(at:NSURL) throws{
    
    let fm = NSFileManager.defaultManager()
    
    guard !fm.fileExistsAtPath(at.absoluteString) else{
        throw SlickDataErrors.FileExists(url: at)
    }
    
    do{
        try fm.createDirectoryAtURL(at, withIntermediateDirectories: true, attributes: nil)
    }catch let err as NSError{
        throw SlickDataErrors.FileSystemError(err: err)
    }
}