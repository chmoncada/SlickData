//
//  Errors.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 04/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

public enum SlickDataErrors : ErrorType{
    
    case FileExists(url: NSURL)
    case FileSystemError(err: NSError)
    case GenericError(description: String)
    
}