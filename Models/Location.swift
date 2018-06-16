//
//  Location.swift
//  mr0
//
//  Created by Ted Shaffer on 5/20/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation
import GooglePlaces

struct Location: Codable {
    var latitude: Double
    var longitude: Double
}

//struct Location {
//    let latitude : Double;
//    let longitude : Double;
//
//    init(latitude : Double, longitude : Double) {
//        self.latitude = latitude;
//        self.longitude = longitude;
//    }
//}
//
//extension Location: Decodable {
//
//    enum MyStructKeys: String, CodingKey { // declaring our keys
//        case latitude = "latitude"
//        case longitude = "longitude"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
//        let latitude: CLLocationDegrees = try container.decode(Double.self, forKey: .latitude) // extracting the data
//        let longitude: CLLocationDegrees = try container.decode(Double.self, forKey: .longitude) // extracting the data
//
//        self.init(latitude : latitude, longitude : longitude) // initializing our struct
//    }
//}
//    var latitude : CLLocationDegrees = 0
//    var longitude : CLLocationDegrees = 0
//
//    var foodType : FoodType = .Other
//    var comments : String = ""
//    var dateVisited = Date()
//    //    var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
//    var latitude : CLLocationDegrees = 0;
//    var longitude : CLLocationDegrees = 0;
//}
