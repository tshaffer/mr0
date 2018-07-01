//
//  MenuItem.swift
//  mr0
//
//  Created by Ted Shaffer on 6/30/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
    
    var label : String
    
    init(label : String) {
        self.label = label
    }
}