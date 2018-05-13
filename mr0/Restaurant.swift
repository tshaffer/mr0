//
//  Restaurant.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation

class Restaurant: Codable {
    
    var name : String = ""
    var foodType : String = "Other"
    var comments : String = ""
    var dateVisited = Date()
}
