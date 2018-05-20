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
        
    override func viewDidLoad() {
        print ("MemoRappViewController viewDidLoad")
        super.viewDidLoad()
        
        let restaurantsDB = Database.database().reference().child("Restaurants")
        restaurantsDB.observe(.childAdded, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                
                print(getData)
                
                let sender = getData["Sender"] as? String
                print(sender ?? "senderPoo")
                
                let restaurantBody = getData["RestaurantBody"] as? String
                print(restaurantBody ?? "restaurantBodyPoo")
                
                let jsonData = restaurantBody?.data(using: .utf8)
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
                print(dictionary!)
                let aD = dictionary as! Dictionary<String, AnyObject>
                
                let name = aD["name"]
                print(name as Any)
                print(name!)
                let comments = aD["comments"]
                print(comments as Any)
                print(comments!)
                
//                let wins = getData["wins"] as? String
                
//                let jsonString = "{\"nacho\":[\"1\",\"2\",\"3\"]}"
//                let jsonData = jsonString.data(using: .utf8)
//                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
//                print(dictionary!)
                
//                let encoder = JSONEncoder()
//                encoder.outputFormatting = .prettyPrinted
//
//                do {
//                    let data = try encoder.encode(getData)
//                    print(String(data: data, encoding: .utf8)!)
//                    let dataAsString = String(data: data, encoding: .utf8)!
//                    print(dataAsString)
//                    let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
//                                                "RestaurantBody": dataAsString] as [String : Any]
//                    restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
//                        (error, reference) in
//                        if (error != nil) {
//                            print(error!)
//                        }
//                        else {
//                            print("Restaurant saved successfully")
//                        }
//                    }
//                }
//                catch {
//                    print("encoder error")
//                }
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


