//
//  RestaurantReviewViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase

class RestaurantReviewViewController: UIViewController, SpecifyFoodTypeDelegate {

    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var visitDate: UIDatePicker!
    
    var foodType: FoodType = .Other
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    func specifyFoodType(foodType: FoodType) {
        print("specifyFoodType = is \(foodType)")
        self.foodType = foodType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        print("button pressed")
        print(restaurantName.text!)
        print(comments.text!)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: visitDate.date)
        print(selectedDate)
        
        // add restaurant information to the database
        let restaurantsDB = Database.database().reference().child("Restaurants")
        
        let restaurant : Restaurant = Restaurant()
        restaurant.name = restaurantName.text!
        restaurant.foodType = self.foodType
        restaurant.comments = comments.text!
        restaurant.dateVisited = visitDate.date
       
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

    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant review prepare for segue invoked")
        
        if segue.identifier == "specifyFoodTypeSegue" {
            let vc = segue.destination as! FoodTypeTableViewController
            vc.specifyFoodTypeDelegate = self
        }
    }


}
