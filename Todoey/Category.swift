//
//  Category.swift
//  Todoey
//
//  Created by Adarsha Upadhya on 18/12/18.
//  Copyright © 2018 Adarsha Upadhya. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
    
}
 
