//
//  ViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/5/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class MemoRappViewController: UITableViewController {
    
    var restaurants = [Restaurant]()

    override func viewDidLoad() {
        print ("MemoRappViewController viewDidLoad")
        super.viewDidLoad()
        
        let restaurantsDB = Database.database().reference().child("Restaurants")
        restaurantsDB.observe(.childAdded, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                
                print(getData)
                
                let sender = getData["Sender"] as? String
                let restaurantBodyJSON = getData["RestaurantBody"] as? String
                let jsonData = restaurantBodyJSON?.data(using: .utf8)
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
                let restaurantDictionary = dictionary as! Dictionary<String, AnyObject>
                
                let name = restaurantDictionary["name"]
                let foodType = restaurantDictionary["foodType"]
                let comments = restaurantDictionary["comments"]
                let dateVisited = restaurantDictionary["dateVisited"]
                let location = restaurantDictionary["location"]
                
                print(sender ?? "senderPoo")
                print(dictionary!)
                print(name as Any)
                print(name!)
                print(foodType!)
                print(comments as Any)
                print(comments!)
                print(dateVisited!)
                
                print(location!)
                let locationDictionary = location as! Dictionary<String, Double>
                let latitude = locationDictionary["latitude"]
                print(latitude!)

                let longitude = locationDictionary["longitude"]
                print(longitude!)
                
                var restaurant : Restaurant = Restaurant()
                restaurant.name = name as! String
                
                restaurant.foodType = FoodType(rawValue: (foodType as! Int))!
                restaurant.location = Location(latitude: latitude!, longitude: longitude!)
                restaurant.comments = comments as! String
//                restaurant.dateVisited = dateVisited as! Date
                self.restaurants.append(restaurant)
            }
        })
    }

    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare invoked")
        print("segue.identifier ===  \(segue.identifier!)")
        if (segue.identifier == "transitionToPlaces")
        {
            let vc = segue.destination as! MapViewController
            vc.restaurants = restaurants
        }
//        if segue.identifier == "Pizza"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
//        if segue.identifier == "Deep Dish"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
//        if segue.identifier == "Calzone"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
        
    }
}


