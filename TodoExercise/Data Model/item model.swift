//
//  item model.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 02.09.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import Foundation


class Item: Encodable, Decodable { // oder: codeable
    
    var titel : String = ""
    var erledigt : Bool = false
    
    init() {
        
    }
    
}
