//
//  Item.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 07.10.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var titel : String = ""
    @objc dynamic var erledigt : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
