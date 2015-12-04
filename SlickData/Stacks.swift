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

//public class BaseSlickDataStack {
//    
//    //MARK: - Properties
//    let context : NSManagedObjectContext
//    let objectModel : NSManagedObjectModel
//    let storeCoordinator : NSPersistentStoreCoordinator
//    
//    private let _modelURL : NSURL
//    private let _dbFolderURL : NSURL
//    
//    init?(modelName:String, bundle: NSBundle, databaseURL: NSURL){
//        
//        // Full URL for the data model
//        guard let _modelURL = bundle.URLForResource(modelName, withExtension: "momd") else{
//            print("Could not create url for \(modelName).momd in \(bundle)")
//            return nil
//        }
//        
//        // All the db files go inside this folder
//        guard let
//        
//    }
//}
//
////MARK: - Private Interface
//
//class SlickDataStack: BaseSlickDataStack {
//    
//}
//
//class ReadOnlyStack: BaseSlickDataStack {
//    
//}
//
//class InMemoryStack: BaseSlickDataStack {
//    
//}