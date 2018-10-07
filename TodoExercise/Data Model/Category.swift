//
//  Category.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 07.10.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
