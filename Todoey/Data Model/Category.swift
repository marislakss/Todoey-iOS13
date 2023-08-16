//
//  Category.swift
//  Todoey
//
//  Created by Māris Lakšs on 09/08/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    // dynamic means declaration modifier and it tells the runtime
    // to use dynamic dispatch (while your app is running) over static dispatch.
    @objc dynamic var name = ""
    @objc dynamic var color = ""
    // Create relationship between Category and Item.
    // List is a container type (used in Realm framework) for objects of a given class.
    let items = List<Item>()
}
