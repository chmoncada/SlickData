//
//  Jedi+CoreDataProperties.swift
//  SlickData
//
//  Created by Fernando Rodríguez Romero on 21/12/15.
//  Copyright © 2015 Udacity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Jedi {

    @NSManaged var lightSaberColor: String?
    @NSManaged var midichlorians: NSNumber?
    @NSManaged var name: String?
    @NSManaged var image: NSData?
    @NSManaged var master: Jedi?
    @NSManaged var padawans: NSSet?

}
