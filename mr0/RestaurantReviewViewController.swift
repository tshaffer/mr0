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

        // Do any additional setup after loading the view.
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
        
//        var name : String = ""
//        var foodType : FoodType = .Other
//        var comments : String = ""
//        var dateVisited = Date()
        let restaurant : Restaurant = Restaurant()
        restaurant.name = restaurantName.text!
        restaurant.foodType = self.foodType.description
        restaurant.comments = comments.text!
        // date??
       
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
//        let string = "[{\"form_id\":3465,\"canonical_name\":\"df_SAWERQ\",\"form_name\":\"Activity 4 with Images\",\"form_desc\":null}]"
//        let data = string.data(using: .utf8)!
//        do {
//            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
//            {
//                print("good json")
//            } else {
//                print("bad json")
//            }
//        } catch let error as NSError {
//            print(error)
//        }
        
        
//        let jsonEncoder = JSONEncoder()
//        do {
//            let jsonData = try jsonEncoder.encode(restaurant)
//            let json = String(data: jsonData, encoding: String.Encoding.utf16)!
//
////            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
////                                        "RestaurantBody": jsonData] as [String : Any]
//            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
//                                        "RestaurantBody": json] as [String : Any]
//
//            restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
//                (error, reference) in
//                if (error != nil) {
//                    print(error!)
//                }
//                else {
//                    print("Restaurant saved successfully")
//                }
//            }
////            let decoder = JSONDecoder()
////            let product = try decoder.decode(Restaurant.self, from: jsonData)
//        }
//        catch {
//            print("encoder error")
//        }

        
//        let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
//                                    "RestaurantBody": restaurant] as [String : Any]
//        var restaurantAsJson : String = "";
        
        
//        do {
//            let encodedValue = try restaurant.encode(to: String.Encoding.utf16 as! Encoder)
//            print("encodedValue ", encodedValue)
//        }
//        catch {
//            print("didn't work")
//        }
  
        
        
//        print("restaurantAsJson ", restaurantAsJson)
//
//        let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
//                                    "RestaurantBody": restaurantAsJson] as [String : Any]
//
//        restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
//            (error, reference) in
//
//            if error != nil {
//                print(error!)
//            }
//            else {
//                print("Restaurant saved successfully!")
//            }
//
////            self.messageTextfield.isEnabled = true
////            self.sendButton.isEnabled = true
////            self.messageTextfield.text = ""
//
//
//        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant review prepare for segue invoked")
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
        if segue.identifier == "specifyFoodTypeSegue" {
            let vc = segue.destination as! FoodTypeTableViewController
            vc.specifyFoodTypeDelegate = self
        }
    }


}
