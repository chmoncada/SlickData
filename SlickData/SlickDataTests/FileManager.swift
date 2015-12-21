//
//  FileManager.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 21/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//
//  Extensions to NSFileManager

import Foundation


extension NSFileManager{
    
    // The func fileExistsAtPath(_ path: String, isDirectory isDirectory: UnsafeMutablePointer<ObjCBool>) -> Bool
    // is awkword in Swift, as part of the information it returns goes into a pointer to an
    // ObjectiveC BOOL.
    // As Swift can return several values, there's no need for this. Our wrapper
    // will return a tuple with the Bool value for the existence of the file
    // and also a flag that indicates if it's actually a folder.
    typealias FileSystemObjectInfo = (exists: Bool, isFolder: Bool)
    
    
    func fileSystemObjectInfoAtPath(path: String) -> FileSystemObjectInfo{
        
        var isDirectory: ObjCBool = ObjCBool(false)
        let exists = self.fileExistsAtPath(path, isDirectory: &isDirectory)
        
        let info = FileSystemObjectInfo(exists: exists, isFolder: Bool(isDirectory))
        return info
        
    }
    
    
    
}