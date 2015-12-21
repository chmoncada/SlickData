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
    private var _mainContext : NSManagedObjectContext?

    
    

    init?(modelName:String, bundle: NSBundle, databaseURL: NSURL){
        
        let objectModel : NSManagedObjectModel
        let storeCoordinator : NSPersistentStoreCoordinator
        let dbFolderURL : NSURL
        
        let fm = NSFileManager.defaultManager()

        // That momd file (the model) better exist inside the bundle
        guard let modelURL = bundle.URLForResource(modelName, withExtension: "momd") else{
            print("Could not create url for \(modelName).momd in \(bundle). Maybe there's no \(modelName) inside \(bundle)")
            return nil
        }
        
        // databaseURL:
        // * must be a file url
        // * must exist
        // * must be a folder
        // * will create a subfolder named 'modelName'
        guard let dbPath = databaseURL.path else{
            print("\(databaseURL) must be a file url!")
            return nil
        }
        
        let info = fm.fileSystemObjectInfoAtPath(dbPath)
        if info.exists == false{
            print("\(dbPath) doesn't exist")
            return nil
        }
        if info.isFolder == false {
            print("\(dbPath) is not a folder")
            return nil
        }
        
        
        // Create a subfolder that contains all the db files (sqlite and blobs)
        dbFolderURL = databaseURL.URLByAppendingPathComponent(modelName)
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
        
        
        _mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        _mainContext!.persistentStoreCoordinator = storeCoordinator

    }
    
    
}

extension BaseSlickDataStack {
    // Convenience Inits
    convenience init?(modelName: String){
        // Finds the model in the Main Bundle (this might fail in tests!)
        // and creates or opens the db inside the documents folder
        
        let fm = NSFileManager.defaultManager()
        
        self.init(modelName: modelName,
            bundle: NSBundle.mainBundle(),
            databaseURL: fm.documentsURL())
        
    }
    
    convenience init?(temporaryStackWithModelName modelName: String){
        // Finds the model in the Main Bundle (might fail in tests)
        // and creates or opens the db inside the caches folder.
        // This data might be deleted by the OS!!!
        // Use it for temporary stuff, or else!!
        
        let fm = NSFileManager.defaultManager()
        
        self.init(modelName: modelName,
            bundle: NSBundle.mainBundle(),
            databaseURL: fm.cachesURL())
    }
}

extension BaseSlickDataStack{
    
    // Saving to disk: throws an NSError
    func commitMainContext() throws{
        try _mainContext?.save()
    }
    
    
}

//MARK: - Private Interface
class SlickDataStack: BaseSlickDataStack {
    
    
}

class ReadOnlyStack: BaseSlickDataStack {
    
}

class InMemoryStack: BaseSlickDataStack {
    
}