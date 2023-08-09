//
//  RealmData.swift
//  Todoey
//
//  Created by Māris Lakšs on 09/08/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

// Object is a class that defines your Realm data model.
class RealmData: Object {
    // dynamic means declaration modifier and it tells the runtime
    // to use dynamic dispatch (while your app is running) over static dispatch.
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}

