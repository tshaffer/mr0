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
        
    var dbId : String = ""
    var name : String = ""
    var rating : Float = 5.0
    // priceRange?

    var tags = [String]()
    var comments : String = ""
    var location : Location = Location(latitude : 0, longitude : 0);
    var photos = [PhotoItem]()
    var menuItems = [MenuItem]()

    var restaurantVisits = [RestaurantVisit]()
    
    init() {
        let restaurantVisit = RestaurantVisit()
        self.restaurantVisits.append(restaurantVisit)
    }
}
