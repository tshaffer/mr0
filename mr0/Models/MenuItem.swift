//
//  MenuItem.swift
//  mr0
//
//  Created by Ted Shaffer on 6/30/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
    
    var name : String = ""
    var comments : String = ""
    var rating : Float = 5.0
    
    init(name : String) {
        self.name = name
    }
}
