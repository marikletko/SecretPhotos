//
//  Photos+CoreDataProperties.swift
//  SecretPhotos
//
//  Created by Kirill Letko on 1/10/20.
//  Copyright © 2020 Letko. All rights reserved.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var photos: Data?

}
