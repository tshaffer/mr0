//
//  Tag.swift
//  mr0
//
//  Created by Ted Shaffer on 6/17/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation

struct Tag: Codable {

    var label : String
    
    init(label : String) {
        self.label = label
    }
}
