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
func createFolder(at:NSURL) throws ->Bool{
    
    let fm = NSFileManager.defaultManager()
    
    guard let path = at.path else{
        throw SlickDataErrors.GenericError(description: "\(at) is not a local url")
    }
    
    guard !fm.fileExistsAtPath(path) else{
        throw SlickDataErrors.FileExists(url: at)
    }
    
    do{
        try fm.createDirectoryAtURL(at, withIntermediateDirectories: true, attributes: nil)
    }catch let err as NSError{
        throw SlickDataErrors.FileSystemError(err: err)
    }
    return true
}

//MARK: - FileManager extensions
extension NSFileManager{
    
    func cachesURL()->NSURL{
        return urlForDirectory(.CachesDirectory)
    }
    
    func documentsURL()->NSURL{
        return urlForDirectory(.DocumentDirectory)
    }
    
    func urlForDirectory(directory: NSSearchPathDirectory) ->NSURL{
        let urls = NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urls.first!
    }
}