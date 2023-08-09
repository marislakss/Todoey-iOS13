//
//  Item.swift
//  Todoey
//
//  Created by Māris Lakšs on 09/08/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    // dynamic means declaration modifier and it tells the runtime
    // to use dynamic dispatch (while your app is running) over static dispatch.
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    // Define inverse relationship between Item and Category.
    // LinkingObjects is a container type for objects of a given class that
    // links back to parent category.ß
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
