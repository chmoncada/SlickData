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
    private var _storeCoordinator : NSPersistentStoreCoordinator?
    
    //MARK : - Autosave
    var autoSave : Bool = false
    var autoSaveDelayInSeconds : Int = 60
    private var autoSaver : ContextAutoSaver?


    init?(modelName:String, bundle: NSBundle, databaseURL: NSURL){
        
        let objectModel : NSManagedObjectModel
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
        _dbURL = dbFolderURL.URLByAppendingPathComponent(modelName).URLByAppendingPathExtension("sqlite")
        
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
        
        _storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        do{
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption : true]
            
            try _storeCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType,
                configuration: nil, URL: _dbURL, options: options)
        }catch let err as NSError{
            print("Error adding a SQLite store: \(err)")
            return nil
        }
        
        
        _mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        _mainContext!.persistentStoreCoordinator = _storeCoordinator
        
        
        // Autosaver
        autoSaver = ContextAutoSaver(context: _mainContext!)
        autoSaver!.on = autoSave
        autoSaver!.intervalInSeconds = autoSaveDelayInSeconds
    }
    
    

}

//MARK: - Convenience Inits
extension BaseSlickDataStack {
    
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

//MARK: - Context
extension BaseSlickDataStack{
    
    typealias ContextHandler = (context: NSManagedObjectContext)->Void
    
    func performWithMainContext(handler: ContextHandler){
        
        dispatch_sync(dispatch_get_main_queue()) { () -> Void in
            handler(context: self._mainContext!)
        }
        
        
    }
    
    var mainContext : NSManagedObjectContext{
        return _mainContext!
    }
}

//MARK: - File System
extension BaseSlickDataStack{
    
    // Saving to disk: throws an NSError
    func commitMainContext() throws{
        try _mainContext?.save()
    }
    
    
    func deleteAllData() throws{
        
        // delete all the objects in the db. This won't delete the files, it will
        // just leave empty tables.
        try _storeCoordinator?.destroyPersistentStoreAtURL(_dbURL!, withType: NSSQLiteStoreType, options: nil)
        
        // Delete all external blobs (anything wich isn't a sqlite or finder file)
        let folder = _dbURL?.URLByDeletingLastPathComponent!
        let fm = NSFileManager.defaultManager()
        var filesToDelete = try fm.contentsOfDirectoryAtPath((folder?.path)!)
        
        let sqlite = ["sqlite", "sqlite-shm", "sqlite-wal"]
        let finder = [".localized", ".DS_Store"]
        
        let finderPred = NSPredicate(format: "NOT self IN %@", finder)
        let sqlitePred = NSPredicate(format: "pathExtension IN %@", sqlite)
        
        var filter = NSCompoundPredicate(notPredicateWithSubpredicate: sqlitePred)
        filter = NSCompoundPredicate(andPredicateWithSubpredicates: [filter,finderPred])
        
        // Get all the file names to delete
        filesToDelete = filesToDelete.filter{filter.evaluateWithObject($0)}
        
        // Delete
        for eachFile in filesToDelete{
            let fileURL = folder?.URLByAppendingPathComponent(eachFile)
            try fm.removeItemAtURL(fileURL!)
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



