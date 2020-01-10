//
//  Entity+CoreDataProperties.swift
//  SecretPhotos
//
//  Created by Kirill Letko on 1/10/20.
//  Copyright © 2020 Letko. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var photos: Data?

}
