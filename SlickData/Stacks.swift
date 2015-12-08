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
    // As of December 2015, there's a bug in version 1.1 of the Swift
    // compiler that affects instances of classes with stored properties
    // and failable initializers. Even in the case where the init? returns
    // nil, values must be assigned to the stored properties. Even if they
    // will never be used.
    // See https://devforums.apple.com/thread/251388?start=0&tstart=0
    // A possible workaround is to have the stored properties declared
    // as Optionals, even though it's not semantically correct, and bind
    // them to nil at the beginning of the init?
    private var _dbURL : NSURL?
    private var _context : NSManagedObjectContext?

    
    

    init?(modelName:String, bundle: NSBundle, databaseURL: NSURL){
        
        let objectModel : NSManagedObjectModel
        let storeCoordinator : NSPersistentStoreCoordinator
        let dbFolderURL : NSURL
        

        guard let modelURL = bundle.URLForResource(modelName, withExtension: "momd") else{
            print("Could not create url for \(modelName).momd in \(bundle)")
            return nil
        }
        
        // Create a folder that contains all the db files (sqlite and blobs)
        let fm = NSFileManager.defaultManager()
        dbFolderURL = fm.documentsURL().URLByAppendingPathComponent(modelName)
        _dbURL = dbFolderURL.URLByAppendingPathComponent(modelName)
        
        // if the folder doesn't exist, go ahead and create it
        if !fm.fileExistsAtPath(dbFolderURL.path!){
            do{
                try createFolder(dbFolderURL)
            }catch{
                print("Unable to create folder at \(dbFolderURL)")
                return nil
            }
        }
        
        // Create the Stack: this will either open or create the sqlite db file
        objectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        do{
            try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                configuration: nil, URL: _dbURL, options: nil)
        }catch let err as NSError{
            print("Error adding a SQLite store: \(err)")
            return nil
        }
        
        
        _context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        _context!.persistentStoreCoordinator = storeCoordinator

  
    }
}

//MARK: - Private Interface

class SlickDataStack: BaseSlickDataStack {
    
}

class ReadOnlyStack: BaseSlickDataStack {
    
}

class InMemoryStack: BaseSlickDataStack {
    
}