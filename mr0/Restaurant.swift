//
//  Restaurant.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation
import GooglePlaces

struct Restaurant: Codable {
    
    var name : String = ""
    
    var rating : Float = 0.0

    // cost? Priciness?

    // variable name (items?), type?
    var foodTypes = [String]()
    
    var comments : String = ""
    
    var location : Location = Location(latitude : 0, longitude : 0);
    // address?
    
    var restaurantVisits = [RestaurantVisit]()

    var photos = [PhotoItem]()
 }
