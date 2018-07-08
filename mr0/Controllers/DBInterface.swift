//
//  DBInterface.swift
//  mr0
//
//  Created by Ted Shaffer on 7/8/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation
import Firebase

protocol DBInterfaceDelegate {
    func dbLoaded()
}

class DBInterface {
    
    static var restaurants = [Restaurant]()

    static var dbInterfaceDelegate : DBInterfaceDelegate?

    static func loadDB() {
        loadRestaurants()
    }
    
    static func getRestaurants() -> [Restaurant] {
        return restaurants
    }
    
    static func saveRestaurant(restaurantIn: Restaurant) {
        
        // TODO - don't understand the error message that occurred when I didn't include this shenanigans
        var restaurant : Restaurant = restaurantIn
        
        let restaurantsDB = Database.database().reference().child("Restaurants")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            
            if (restaurant.dbId == "") {
                restaurant.dbId = UUID().uuidString
            }
            
            let data = try encoder.encode(restaurant)
            print(String(data: data, encoding: .utf8)!)
            let dataAsString = String(data: data, encoding: .utf8)!
            print(dataAsString)
            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
                                        "RestaurantBody": dataAsString] as [String : Any]
            
            restaurantsDB.child((restaurant.dbId)).setValue(restaurantDictionary) {
                (error, reference) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    print("Restaurant saved successfully")
                }
            }
        }
        catch {
            print("encoder error")
        }
    }
    
    static func loadRestaurants() {
        
        // load restaurants from firebase
        let restaurantsTable = Database.database().reference().child("Restaurants")
        
        restaurantsTable.observe(.childAdded, with: { (snapshot) in
            
            if let getData = snapshot.value as? [String:Any] {
                
                _ = getData["Sender"] as? String
                let restaurantBodyJSON = getData["RestaurantBody"] as? String
                let jsonData = restaurantBodyJSON?.data(using: .utf8)
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
                let restaurantDictionary = dictionary as! Dictionary<String, AnyObject>
                
                let name : String = restaurantDictionary["name"] as! String
                let comments = restaurantDictionary["comments"] as! String
                let tags = restaurantDictionary["tags"] as! [String]
                let rating = restaurantDictionary["rating"] as! Float

                var menuItems = [MenuItem]()
                
                let menuItemsDictionaryArray = restaurantDictionary["menuItems"] as! [Dictionary<String, AnyObject>]
                for menuItemDictionary in menuItemsDictionaryArray {
//                    let menuItemDictionary = menuItemDictionaryItem as Dictionary<String, AnyObject>
                    let menuItemName = menuItemDictionary["name"]
                    let menuItemComments = menuItemDictionary["comments"]
                    let menuItemRating = menuItemDictionary["rating"]
                    
                    var menuItem = MenuItem(name: menuItemName as! String)
                    menuItem.comments = menuItemComments as! String
                    menuItem.rating = menuItemRating as! Float
                    
                    menuItems.append(menuItem)
                }
                
                var restaurantVisits = [RestaurantVisit]()
                
                let restaurantVisitDictionaries = restaurantDictionary["restaurantVisits"] as! [Dictionary<String, AnyObject>]
                for restaurantVisitDictionary in restaurantVisitDictionaries {
                    
                    var restaurantVisit = RestaurantVisit()
                    
                    let visitDate = restaurantVisitDictionary["dateVisited"] as! TimeInterval
                    restaurantVisit.dateVisited = Date.init(timeIntervalSinceReferenceDate: visitDate)
                    
                    restaurantVisits.append(restaurantVisit)
                }
                
                let location = restaurantDictionary["location"]
                let locationDictionary = location as! Dictionary<String, Double>
                let latitude = locationDictionary["latitude"]
                let longitude = locationDictionary["longitude"]
                
                var restaurant : Restaurant = Restaurant()
                restaurant.dbId = snapshot.key
                restaurant.name = name
                restaurant.location = Location(latitude: latitude!, longitude: longitude!)
                restaurant.comments = comments
                
                restaurant.tags.removeAll()
                for tag in tags {
                    restaurant.tags.append(tag)
                }
                
                restaurant.menuItems = menuItems
                
                restaurant.rating = rating
                
                restaurant.restaurantVisits = restaurantVisits
                
                restaurants.append(restaurant)
            }
            dbInterfaceDelegate?.dbLoaded()
        })
    }
}
