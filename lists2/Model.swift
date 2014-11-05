//
//  Model.swift
//  lists2
//
//  Created by Razvigor Andreev on 11/2/14.
//  Copyright (c) 2014 Razvigor Andreev. All rights reserved.
//

import UIKit
import CoreData

@objc(Model)

class Model: NSManagedObject {
    
    // properties feeding the attributes in our entity
    // Must match the entity attributes
    
    @NSManaged var item: String
    @NSManaged var quantity: String
    @NSManaged var info: String
    @NSManaged var imagePath: String
    @NSManaged var imageCheck: String
    @NSManaged var price: Double
    
   
}
