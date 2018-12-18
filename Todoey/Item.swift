//
//  Item.swift
//  Todoey
//
//  Created by Adarsha Upadhya on 17/12/18.
//  Copyright © 2018 Adarsha Upadhya. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
  @objc dynamic var title:String = ""
  @objc dynamic var  done:Bool = false
  @objc dynamic var createdDate:Date?
    
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
