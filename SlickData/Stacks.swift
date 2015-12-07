//
//  Stacks.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 04/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Public Interface
//: This is the public interface to the 
// :[class cluster](https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/ClassCluster.html )

public class BaseSlickDataStack {
    
    //MARK: - Properties
    let context : NSManagedObjectContext
    let objectModel : NSManagedObjectModel
    let storeCoordinator : NSPersistentStoreCoordinator
    
    private let _modelURL : NSURL
    private let _dbFolderURL : NSURL
    private let _dbURL : NSURL
    
    init?(modelName:String, bundle: NSBundle, databaseURL: NSURL){
        
        var errorMessage : String? = nil
        
        // Full URL for the data model
        if let modelURL = bundle.URLForResource(modelName, withExtension: "momd"){
            _modelURL = modelURL
            
            // All the db files go inside this folder
            let fm = NSFileManager.defaultManager()
            _dbFolderURL = fm.documentsURL().URLByAppendingPathComponent(modelName)
            _dbURL = _dbFolderURL.URLByAppendingPathComponent(modelName)
            
            // If it doesn't exist, create it
            if !fm.fileExistsAtPath(_dbFolderURL.path!){
                do{
                    try createFolder(_dbFolderURL)
                }catch{
                    errorMessage = "Unable to create folder at \(_dbFolderURL)"
                }
            }

            // Create the Stack
            objectModel = NSManagedObjectModel(contentsOfURL: _modelURL)!
            
            storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
            do{
                try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: _dbURL, options: nil)
            }catch let err as NSError{
                errorMessage = "Error adding a SQLite store: \(err)"
            }
            
            context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context.persistentStoreCoordinator = storeCoordinator

            
        }else{
            errorMessage = "Could not create url for \(modelName).momd in \(bundle)"
        }
        
        
        // if the has been any errors, return nil
        if let errorMessage = errorMessage{
            print(errorMessage)
            return nil
        }
        

        
        
    }
}

//MARK: - Private Interface

class SlickDataStack: BaseSlickDataStack {
    
}

class ReadOnlyStack: BaseSlickDataStack {
    
}

class InMemoryStack: BaseSlickDataStack {
    
}