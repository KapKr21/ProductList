//
//  Product+CoreDataProperties.swift
//  TaskByDucktale
//
//  Created by Kap's on 05/07/20.
//  Copyright © 2020 Kapil. All rights reserved.
//
//

import Foundation
import CoreData

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productName: String?
    @NSManaged public var productQuantity: Int32

}
