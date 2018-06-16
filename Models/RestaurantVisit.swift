//
//  RestaurantVisit.swift
//  mr0
//
//  Created by Ted Shaffer on 6/8/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation

struct RestaurantVisit: Codable {
    
    var dateVisited = Date()
    var comments : String = ""
    var rating : Float = 0.0
    var photos = [PhotoItem]()
}
