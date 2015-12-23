//
//  CoreData.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 22/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import CoreData

extension  NSManagedObjectContext{
    
    
    
    private func autoSave(afterDelay delay: NSNumber){
        
        do{
            if hasChanges{
                try save()
                performSelector("autoSave", withObject: delay, afterDelay: delay.doubleValue)
            }
        }catch let err as NSError{
            print("Error while trying to auto save: \(err)")
        }
    }
    
}

