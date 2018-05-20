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
    var foodType : FoodType = .Other
    var comments : String = ""
    var dateVisited = Date()
//    var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
//    var latitude : CLLocationDegrees = 0;
//    var longitude : CLLocationDegrees = 0;
    var location : Location = Location(latitude : 0, longitude : 0);
}
