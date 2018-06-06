//
//  RestaurantViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/5/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import GooglePlaces

class RestaurantViewController: UIViewController, SpecifyFoodTypeDelegate {

    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var visitDateBtn: UIButton!
    
    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()
    var selectedDate: String = ""

    var foodType: FoodType = .Other

    var visitDate : Date = Date.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantName.text = selectedPlace!.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        selectedDate = dateFormatter.string(from: visitDate)
        visitDateBtn.setTitle(selectedDate,for: .normal)

        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func setFoodTypes(_ sender: Any) {
    }
    
    @IBAction func setVisitDate(_ sender: Any) {
    }
    
    func specifyFoodType(foodType: FoodType) {
        print("specifyFoodType is \(foodType)")
        self.foodType = foodType
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant review prepare for segue invoked")
        
        if segue.identifier == "specifyFoodTypeSegue" {
            let vc = segue.destination as! FoodTypeTableViewController
            vc.specifyFoodTypeDelegate = self
        }
        
        
    }

    @IBAction func submitRestaurantBtn(_ sender: Any) {
        
        // add restaurant information to the database
        let restaurantsDB = Database.database().reference().child("Restaurants")
        
        var restaurant : Restaurant = Restaurant()
        restaurant.name = restaurantName.text!
        restaurant.foodType = self.foodType
        restaurant.comments = comments.text!
        restaurant.dateVisited = visitDate
        restaurant.location = Location(latitude: (selectedPlace?.coordinate)!.latitude, longitude: (selectedPlace?.coordinate)!.longitude);
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(restaurant)
            print(String(data: data, encoding: .utf8)!)
            let dataAsString = String(data: data, encoding: .utf8)!
            print(dataAsString)
            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
                                        "RestaurantBody": dataAsString] as [String : Any]
            restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
