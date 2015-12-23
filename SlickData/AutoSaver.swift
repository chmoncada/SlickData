//
//  AutoSaver.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 23/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import CoreData


// MARK : - Autosaver
class ContextAutoSaver : NSObject{
    
    private var _autoSaveFlag = false
    private var _autoSaveDelayInSeconds = 60
    private let _context : NSManagedObjectContext
    
    
    init(context: NSManagedObjectContext) {
        _context = context
    }
    
    
    var on : Bool{
        get{
            return _autoSaveFlag
        }
        set{
            _autoSaveFlag = newValue
            if _autoSaveFlag{
                autoSave()
            }else{
                // cancel the next call to autoSave
                NSObject.cancelPreviousPerformRequestsWithTarget(self)
            }
        }
    }
    
    var intervalInSeconds : Int{
        get{
            return _autoSaveDelayInSeconds
        }
        set{
            _autoSaveDelayInSeconds = newValue
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
            autoSave()
        }
    }
    
    
    private func autoSave(){
    
        if _autoSaveFlag && _context.hasChanges{
            do{
                try _context.save()
                performSelector("autoSave", withObject: nil, afterDelay: Double(_autoSaveDelayInSeconds))
                
            }catch let err as NSError{
                print("Error while trying to autosave: \(err)")
                _autoSaveFlag = false
            }
        }
    }
}
